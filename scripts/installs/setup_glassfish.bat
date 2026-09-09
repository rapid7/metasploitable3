mkdir C:\glassfish
powershell -ExecutionPolicy Bypass -File "C:\vagrant\resources\glassfish\installs\download_glassfish.ps1"
cmd /c ""C:\Program Files\7-Zip\7z.exe" -y x "C:\Windows\Temp\glassfish4.zip" -oC:\glassfish"
copy /Y "C:\vagrant\resources\glassfish\admin-keyfile" "C:\glassfish\glassfish4\glassfish\domains\domain1\config\admin-keyfile"
copy /Y "C:\vagrant\resources\glassfish\domain.xml" "C:\glassfish\glassfish4\glassfish\domains\domain1\config\domain.xml"
cmd.exe /c "C:\glassfish\glassfish4\bin\asadmin.bat create-service domain1"
net start domain1
powershell -Command "Start-Sleep -s 10"
net stop domain1
icacls "C:\glassfish" /grant "NT Authority\LOCAL SERVICE:(OI)(CI)F" /T
sc config "domain1" obj= "NT Authority\LOCAL SERVICE"
