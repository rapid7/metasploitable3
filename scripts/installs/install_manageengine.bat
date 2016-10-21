powershell -Command "(New-Object System.Net.WebClient).DownloadFile('http://archives.manageengine.com/desktop-central/91084/ManageEngine_DesktopCentral.exe', 'C:\Windows\Temp\ManageEngine_DesktopCentral.exe')" <NUL
start /WAIT C:\Windows\Temp\ManageEngine_DesktopCentral.exe /w /s /f1C:\Vagrant\resources\manageengine\setup.iss
