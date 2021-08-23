powershell -Command "[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true} ; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://archives.manageengine.com/desktop-central/91084/ManageEngine_DesktopCentral.exe', 'C:\Windows\Temp\ManageEngine_DesktopCentral.exe')" <NUL
start /WAIT C:\Windows\Temp\ManageEngine_DesktopCentral.exe /w /s /f1C:\Vagrant\resources\manageengine\setup.iss
net stop "ManageEngine Desktop Central Server"
net stop "MEDC Server Component - Apache"
net stop "MEDC Server Component - Notification Server"
icacls "C:\ManageEngine" /grant "NT Authority\LOCAL SERVICE:(OI)(CI)F" /T
sc config "DesktopCentralServer" obj= "NT Authority\LOCAL SERVICE" type= own start= auto
sc config "MEDC Server Component - Notification Server" obj= "NT Authority\LOCAL SERVICE" type= own start= auto
sc config "MEDCServerComponent-Apache" obj= "NT Authority\LOCAL SERVICE" type= own start= auto
net start "MEDC Server Component - Apache"
net start "MEDC Server Component - Notification Server"
net start "ManageEngine Desktop Central Server"

