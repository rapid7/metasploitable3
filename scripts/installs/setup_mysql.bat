copy C:\Vagrant\resources\mysql\my.ini C:\wamp\bin\mysql\mysql5.5.20
cmd /c ""C:\wamp\bin\mysql\mysql5.5.20\bin\mysql.exe" -u root --password=""  wordpress < "C:\Vagrant\resources\mysql\update_mysql_permissions.sql""
net stop wampmysqld
net start wampmysqld
