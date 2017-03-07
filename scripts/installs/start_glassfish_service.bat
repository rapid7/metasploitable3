Taskkill /IM domain1Service.exe /F
powershell -command "Start-Sleep -s 5"
net start "domain1 GlassFish Server"
