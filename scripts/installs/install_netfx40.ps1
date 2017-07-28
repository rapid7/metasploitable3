# setup dotnetfx4
$netfx_url = "https://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe"

Write-Output "Downloading $netfx_url"
(New-Object System.Net.WebClient).DownloadFile($netfx_url, "C:\Windows\Temp\dotNetFx40_Full_x86_x64.exe")
Write-Output "Starting Install of dotNetFx40_Full_x86_x64.exe"
Start-Process "C:\Windows\Temp\dotNetFx40_Full_x86_x64.exe" "/q /norestart" -Wait
