mkdir C:\glassfish
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('http://download.java.net/glassfish/4.0/release/glassfish-4.0.zip', 'C:\Windows\Temp\glassfish4.zip')" <NUL
cmd /c ""C:\Program Files\7-Zip\7z.exe" x "C:\Windows\Temp\glassfish4.zip" -oC:\glassfish"
copy /Y "C:\vagrant\resources\glassfish\admin-keyfile" "C:\glassfish\glassfish4\glassfish\domains\domain1\config\admin-keyfile"
copy /Y "C:\vagrant\resources\glassfish\domain.xml" "C:\glassfish\glassfish4\glassfish\domains\domain1\config\domain.xml"

C:\glassfish\glassfish4\bin\asadmin.bat create-service domain1

sc config domain1 obj= "NT Authority\LOCAL SERVICE"
icacls "C:\glassfish" /grant "NT Authority\LOCAL SERVICE:(OI)(CI)F" /T
