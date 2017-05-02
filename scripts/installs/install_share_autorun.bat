copy C:\vagrant\scripts\installs\setup_linux_share.bat C:\Windows
reg add HKLM\Software\Microsoft\Windows\CurrentVersion\Run /v share /t REG_SZ /d "C:\Windows\setup_linux_share.bat" /f
