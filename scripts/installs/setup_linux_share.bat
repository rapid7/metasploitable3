@echo off
ping -n 1 -4 172.28.128.3 | find /i "TTL=" > nul
IF ERRORLEVEL 1 (echo "Linux host not available.") ELSE (net use W: \\172.28.128.3\public /user:chewbacca rwaaaaawr5)

