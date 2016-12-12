Taskkill /IM domain1Service.exe /F
ping 192.168.200.201 -n 1 -w 1000 > nul
net start "domain1 GlassFish Server"
