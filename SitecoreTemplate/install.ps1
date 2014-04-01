# env
$web_path = (Get-Location).Path
$root_path = (Get-Item $web_path).parent.FullName
$db_path = Join-Path $root_path "db"
$nuget_server = "http://nuget.lab409.com"
$db_server = ".\sqlexpress"

# params
$sitename = "SitecoreTemplate"
$hostname = "SitecoreTemplate.com"
$packages = @{
    "Sitecore.CMS.7.2.140314" = $web_path;
    "Sitecore.CMS.Db.7.2.140314" = $db_path;
}

# install
$script = {
    Build-Solution
    Set-IisSqlAcessRights $root_path
    Install-Packages $packages
    Create-Website $sitename $hostname $web_path
    Launch-Website $sitename $hostname
}

try {
    . .\install_utils.ps1
    Start-Logging
    Import-Module WebAdministration
    & $script
    Write-InstallCompleted
} catch {
    Write-Host ($_ | Format-List | Out-String) -Foreground 'Red'
    echo "Installation failed."
} finally {
    Stop-Logging
}