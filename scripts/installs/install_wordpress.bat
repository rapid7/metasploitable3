mkdir "C:\Program Files\wordpress"
copy C:\vagrant\resources\wordpress\update_ip.ps1 "C:\Program Files\wordpress\update_ip.ps1"
copy C:\vagrant\resources\wordpress\update_wp_db.bat "C:\Program Files\wordpress\update_wp_db.bat"
cmd /c ""C:\Program Files\7-Zip\7z.exe" x C:\vagrant\resources\wordpress\wordpress.zip -oC:\wamp\www\"
cmd /c ""C:\Program Files\wordpress\update_wp_db.bat""
attrib -r +s C:\wamp\www\wordpress