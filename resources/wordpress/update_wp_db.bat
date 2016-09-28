powershell -File "C:\Program Files\wordpress\update_ip.ps1"
cmd /c ""C:\wamp\bin\mysql\mysql5.5.20\bin\mysql.exe" -u root --password="" -e "drop database wordpress;" "
cmd /c ""C:\wamp\bin\mysql\mysql5.5.20\bin\mysql.exe" -u root --password="" -e "create database wordpress;" "
cmd /c ""C:\wamp\bin\mysql\mysql5.5.20\bin\mysql.exe" -u root --password=""  wordpress < "C:\Program Files\wordpress\wordpress.sql""
del wordpress.sql