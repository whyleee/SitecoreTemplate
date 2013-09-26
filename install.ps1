# params
$package = "Sitecore.CMS.7.0.130918.zip"
$proj_name = "SitecoreTemplate"
$hostname = "sct.com"
$nuget_server = "http://159.224.42.176"

# paths
$root_path = (Get-Location).Path
$web_path = Join-Path $root_path $proj_name

# download
echo "Downloading Sitecore 7..."
$url = $nuget_server + "/content/" + $package
$zip_path = Join-Path $root_path $package
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $zip_path)

# unzip
echo "Unzipping content..."
$shell_app = new-object -com shell.application
$zip_file = $shell_app.namespace($zip_path)
$destination = $shell_app.namespace($web_path)

$destination.Copyhere($zip_file.items())

# iis
echo "Installing website..."
New-WebAppPool $proj_name
Set-ItemProperty "IIS:\AppPools\$proj_name" managedRuntimeVersion v4.0
New-WebSite -Name $proj_name -Port 80 -HostHeader "my.$hostname" -ApplicationPool $proj_name -PhysicalPath "$web_path"
New-WebBinding -Name $proj_name -IPAddress "*" -Port 80 -HostHeader "local.$hostname"

# hosts
echo "Adding hosts..."
$hosts_path = "$env:windir\System32\drivers\etc\hosts"
$hosts_header = @"



######################################################################
# $proj_name
######################################################################

"@
$hosts_line = "127.0.0.1`tmy.$hostname local.$hostname"
$hosts_header + $hosts_line | Out-File -encoding ASCII -append $hosts_path

# cleanup
echo "Cleanup..."
Remove-Item $zip_path

# start
echo "Starting website..."
Start-WebSite $proj_name
start "http://my.$hostname"

echo "Ready to go!"