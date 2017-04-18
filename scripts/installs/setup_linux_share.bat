@echo off
ping -n 1 -4 172.28.128.3 | find /i "TTL=" > nul
IF ERRORLEVEL 1 (echo "Linux host not available.") ELSE (
  cmdkey /add:172.28.128.3 /user:chewbacca /pass:rwaaaaawr5
  net use W: \\172.28.128.3\public /savecred /p:yes
)
