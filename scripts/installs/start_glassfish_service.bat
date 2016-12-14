Taskkill /IM domain1Service.exe /F
powershell -command "Start-Sleep -s 1"
net start "domain1 GlassFish Server"
