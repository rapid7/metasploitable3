$Logfile = "C:\Windows\Temp\dotnet-install.log"
function LogWrite {
   Param ([string]$logstring)
   $now = Get-Date -format s
   Add-Content $Logfile -value "$now $logstring"
   Write-Host $logstring
}
 
LogWrite "Starting installation process..."
try {
    Start-Process -FilePath "C:\vagrant\resources\windows_pre_downloads\dotnet.exe" -ArgumentList "/I /q /norestart" -Wait -PassThru
} catch {
    LogWrite $_.Exception | Format-List -force
    LogWrite "Exception during install process."
}
