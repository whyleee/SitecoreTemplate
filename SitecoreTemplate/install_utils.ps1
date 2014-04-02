################################################################
# PowerShell Functions for website install scripts
################################################################

# requires: WebAdministration

# env
$progress = 0
$log_path = $null

Function Write-InstallProgress($done, $op)
{
    # $status = "$([math]::round($done))% complete"
    # Write-Progress -Activity "Installing $sitename..." -Status $status -PercentComplete $done -CurrentOperation $op
    $progressMsg = "[{0,-4}] $op" -f "$done%"
    echo $progressMsg
}

Function Write-InstallCompleted()
{
    $completeMsg = "Installation finished."
    # Write-Progress -Activity "Installing $sitename..." -Completed -Status "100% complete" -CurrentOperation $completeMsg
    echo "[100%] $completeMsg"
}

Function Start-Logging
{
    if ($VSVersion -eq '12.0') {
        $vs_dir_name = 'Visual Studio 2013\'
    } elseif ($VSVersion -eq '11.0') {
        $vs_dir_name = 'Visual Studio 2012\'
    } else {
        return
    }

    $timestamp = Get-Date -Format 'yyyy-MM-dd.HH-mm-ss'
    $log_dir_path = "$Home\Documents\$vs_dir_name\Logs"
    mkdir -f $log_dir_path > $null
    $script:log_path = Join-Path $log_dir_path ("VisualStudio_SitecoreInstall." + $timestamp + ".txt")
    Continue-Logging
}

Function Continue-Logging
{
    Param([Switch]$Append=$false)
    if ($script:log_path) {
        Start-Transcript -Path $script:log_path -Append:$Append
    }
}

Function Stop-Logging
{
    if ($script:log_path) {
        Stop-Transcript
    }
}

Function Log-Buffer($startText, $endText)
{
    if (!$script:log_path) {
        return
    }

    Stop-Logging
    $ui = $host.ui.rawui
    $height = $ui.CursorPosition.Y
    $width = $ui.BufferSize.Width
    $dims = 0,0,($width-1),$height
    $rect = new-object Management.Automation.Host.Rectangle -argumentList $dims
    $cells = $ui.GetBufferContents($rect)
    $writeLog = $false;

    $startTextList = $startText.Split('|')
    $endTextList = $endText.Split('|')

    for ([int]$row=0; $row -lt $height; $row++ ) {
        $rowText = '';
        for ([int]$col=0; $col -lt $width; $col++ ) {
            $cell = $cells[$row,$col]
            $rowText += $cell.Character
        }
        foreach ($text in $startTextList) {
            if ($rowText.StartsWith($text)) {
                $writeLog = $true
                break
            }
        }
        if ($writeLog){
            Add-Content $script:log_path "$rowText"
        }
        $breakOuter = $false
        foreach ($text in $endTextList) {
            if ($rowText.StartsWith($text)) {
                $breakOuter = $true
                break
            }
        }
        if ($breakOuter) {
            break
        }
    }
    Continue-Logging -Append:$true
}

Function Build-Solution()
{
    Write-InstallProgress $progress "Building solution..."

    $msbuild = "$env:windir\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe"
    $msbuild_args = "/m", "/p:VisualStudioVersion=12.0"
    
    #& $msbuild $msbuild_args | Out-Host # no color
    & $msbuild $msbuild_args
    Log-Buffer "Build succeeded|Build FAILED" "Time Elapsed"

    $script:progress += 30
}

Function Install-Package($package, $to)
{
    $packageZip = "$package.zip"
    New-Item -ItemType Directory -Force -Path $to > $null

    # download
    $url = $nuget_server + "/content/" + $packageZip
    $zip_path = Join-Path (Get-Location).Path $packageZip
    iwr $url -OutFile $zip_path -Credential (Get-Credential)

    # unzip
    $shell_app = new-object -com shell.application
    $zip_file = $shell_app.namespace($zip_path)
    $destination = $shell_app.namespace($to)
    $destination.Copyhere($zip_file.items(), 0x10)

    # cleanup
    Remove-Item $zip_path

    # if db: attach
    if ($packageZip.ToLower().Contains("db")) {
        Install-DbPackage $to
    }
}

Function Set-AccessRights($dir, $who, $rights)
{
    $acl = Get-Acl $dir
    $rights = [System.Security.AccessControl.FileSystemRights] $rights
    $inheritance = [System.Security.AccessControl.InheritanceFlags] 'ContainerInherit, ObjectInherit'
    $acl_rule = New-Object System.Security.AccessControl.FileSystemAccessRule($who, $rights, $inheritance, 'None', 'Allow')
    $acl.AddAccessRule($acl_rule)
    Set-Acl $dir $acl
}

Function Set-IisSqlAcessRights($root_path)
{
    Set-AccessRights $root_path 'BUILTIN\Users' 'ReadAndExecute, Synchronize'
    Set-AccessRights $root_path 'Authenticated Users' 'Modify, Synchronize'
}

Function Install-DbPackage($db_dir)
{
    # add SQL Server 2008 snapins
    Add-PSSnapin SqlServerCmdletSnapin100
    Add-PSSnapin SqlServerProviderSnapin100

    # create db user
    $db_user_name = $sitename + '.Admin'
    $db_user_password = '!QA2ws3ed'
    $create_db_user_sql = @"
CREATE LOGIN [$db_user_name] WITH PASSWORD=N'$db_user_password', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
"@
    Invoke-Sqlcmd -Query $create_db_user_sql -ServerInstance $db_server -Verbose

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

        # map user to db
        $map_user_to_db_sql = @"
USE [$target_db_name]
GO
CREATE USER [$db_user_name] FOR LOGIN [$db_user_name]
GO
EXEC sp_addrolemember N'db_datareader', N'$db_user_name'
EXEC sp_addrolemember N'db_datawriter', N'$db_user_name'
EXEC sp_addrolemember N'db_owner', N'$db_user_name'
"@
        Invoke-Sqlcmd -Query $map_user_to_db_sql -ServerInstance $db_server -Verbose
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