################################################################
# PowerShell Functions for website install scripts
################################################################

# modules
Import-Module WebAdministration

# env
$progress = 0

Function Write-InstallProgress($done, $op)
{
    $status = "$([math]::round($done))% complete"
    Write-Progress -Activity "Installing $sitename..." -Status $status -PercentComplete $done -CurrentOperation $op
    $progressMsg = "[{0,-4}] $op" -f "$done%"
    echo $progressMsg
}

Function Write-InstallCompleted()
{
    $completeMsg = "Installation finished."
    Write-Progress -Activity "Installing $sitename..." -Completed -Status "100% complete" -CurrentOperation $completeMsg
    echo "[100%] $completeMsg"
}

Function Build-Solution()
{
    Write-InstallProgress $progress "Building solution..."

    $msbuild = "$env:windir\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe"
    $msbuild_args = "/m"
    & $msbuild $msbuild_args

    $script:progress += 30
}

Function Install-Package($package, $to)
{
    $packageZip = "$package.zip"
    New-Item -ItemType Directory -Force -Path $to

    # download
    $url = $nuget_server + "/content/" + $packageZip
    $zip_path = Join-Path (Get-Location).Path $packageZip
    $wc = New-Object System.Net.WebClient
    $wc.DownloadFile($url, $zip_path)

    # unzip
    $shell_app = new-object -com shell.application
    $zip_file = $shell_app.namespace($zip_path)
    $destination = $shell_app.namespace($to)
    $destination.Copyhere($zip_file.items(), 0x14)

    # cleanup
    Remove-Item $zip_path

    # if db: attach
    if ($packageZip.ToLower().Contains("db")) {
        Install-DbPackage $to
    }
}

Function Install-DbPackage($db_dir) {
    # Add SQL Server 2008 snapins
    Add-PSSnapin SqlServerCmdletSnapin100
    Add-PSSnapin SqlServerProviderSnapin100

    # attach all dbs in dir to $db_server
    $db_files = ls $db_dir
    for ($i = 0; $i -lt $db_files.Length; $i += 2) {
        # get db-files
        $ldf = Join-Path $db_dir $db_files[$i]
        $mdf = Join-Path $db_dir $db_files[$i + 1]
        $db_name = [IO.Path]::GetFileNameWithoutExtension($mdf)

        # rename all to target proj name
        $templateLdfName = $db_files[$i].ToString().Substring(0, $db_files[$i].ToString().IndexOf('.'))
        $targetLdf = Join-Path $db_dir $db_files[$i].ToString().Replace($templateLdfName, $sitename)
        mv $ldf $targetLdf

        $templateMdfName = $db_files[$i + 1].ToString().Substring(0, $db_files[$i + 1].ToString().IndexOf('.'))
        $targetMdf = Join-Path $db_dir $db_files[$i + 1].ToString().Replace($templateMdfName, $sitename)
        mv $mdf $targetMdf

        $template_db_name = $db_name.Substring(0, $db_name.IndexOf('.'))
        $target_db_name = $db_name.Replace($template_db_name, $sitename)

        # attach to db
        $attach_db_sql = @"
CREATE DATABASE [$target_db_name] ON (FILENAME = N'$targetMdf'), (FILENAME = N'$targetLdf') FOR ATTACH
"@
        Invoke-Sqlcmd -Query $attach_db_sql -ServerInstance $db_server -Verbose
    }
}

Function Install-Packages($packages)
{
    $i = 0
    $packages.GetEnumerator() | % {
        $script:progress = $progress + (60 / $packages.Count) * $i
        Write-InstallProgress $progress "Installing $($_.key)..."
        Install-Package $_.key $_.value
        $i++
    }
    $script:progress = 60
}

Function Create-Website($name, $hostname, $web_path)
{
    Write-InstallProgress $progress "Installing $name website..."

    # iis
    $appPool = New-WebAppPool $name
    $appPool.processModel.identityType = "ApplicationPoolIdentity"
    Set-ItemProperty "IIS:\AppPools\$name" managedRuntimeVersion v4.0
    New-WebSite -Name $name -Port 80 -HostHeader "local.$hostname" -ApplicationPool $name -PhysicalPath "$web_path"
    #New-WebBinding -Name $name -IPAddress "*" -Port 80 -HostHeader "my.$hostname"

    # hosts
    $hosts_path = "$env:windir\System32\drivers\etc\hosts"
    $hosts_header = @"



######################################################################
# $name
######################################################################

"@
    $hosts_line = "127.0.0.1`tlocal.$hostname"
    $hosts_header + $hosts_line | Out-File -encoding ASCII -append $hosts_path

    $script:progress += 5
}

Function Launch-Website($name, $hostname)
{
    Write-InstallProgress $progress "Launching $name website..."

    # launch
    Start-WebSite $name
    start "http://local.$hostname"

    $script:progress += 5
}