$Logfile = "C:\Windows\Temp\wmf-install.log"
function LogWrite {
   Param ([string]$logstring)
   $now = Get-Date -format s
   Add-Content $Logfile -value "$now $logstring"
   Write-Host $logstring
}
 
LogWrite "Downloading Windows Management Framework 5.0"
try {
    (New-Object System.Net.WebClient).DownloadFile('https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win7AndW2K8R2-KB3134760-x64.msu', 'C:\Windows\Temp\wmf.msu')
} catch {
    LogWrite $_.Exception | Format-List -force
    LogWrite "Failed to download file."
}

LogWrite "Starting installation process..."
try {
    Start-Process -FilePath "wusa.exe" -ArgumentList "C:\Windows\Temp\wmf.msu /quiet /norestart" -Wait -PassThru
} catch {
    LogWrite $_.Exception | Format-List -force
    LogWrite "Exception during install process."
}
