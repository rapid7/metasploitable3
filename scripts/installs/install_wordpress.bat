mkdir "C:\Program Files\wordpress"
copy C:\vagrant\resources\wordpress\update_ip.ps1 "C:\Program Files\wordpress\update_ip.ps1"
cmd /c ""C:\Program Files\7-Zip\7z.exe" x C:\vagrant\resources\wordpress\wordpress.zip -oC:\wamp\www\"
cmd /c ""C:\wamp\bin\mysql\mysql5.5.20\bin\mysql.exe" -u root --password=""  -e "create database wordpress;""
cmd /c ""C:\wamp\bin\mysql\mysql5.5.20\bin\mysql.exe" -u root --password=""  wordpress < "C:\Vagrant\resources\wordpress\wordpress.sql""
schtasks /create /tn "update_wp_db" /tr "\"cmd.exe\" /c powershell -File \"C:\Program Files\wordpress\update_ip.ps1\"" /sc onstart /NP /ru "SYSTEM"
powershell -File "C:\Program Files\wordpress\update_ip.ps1"
attrib -r +s C:\wamp\www\wordpress