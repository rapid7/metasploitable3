$Logfile = "C:\Windows\Temp\wmf-install.log"
function LogWrite {
   Param ([string]$logstring)
   $now = Get-Date -format s
   Add-Content $Logfile -value "$now $logstring"
   Write-Host $logstring
}

LogWrite "Downloading dotNet 4.5.2"
try {
    (New-Object System.Net.WebClient).DownloadFile('https://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe', 'windows_pre_downloads/dotnet.exe')
} catch {
    LogWrite $_.Exception | Format-List -force
    LogWrite "Failed to download file."
}

LogWrite "Downloading Windows Management Framework 5.1"
try {
    (New-Object System.Net.WebClient).DownloadFile('https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win7AndW2K8R2-KB3191566-x64.zip', 'windows_pre_downloads/wmf.zip')
} catch {
    LogWrite $_.Exception | Format-List -force
    LogWrite "Failed to download file."
}
