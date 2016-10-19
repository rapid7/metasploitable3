powershell -Command "(New-Object System.Net.WebClient).DownloadFile('http://archive.apache.org/dist/axis/axis2/java/core/1.6.0/axis2-1.6.0-war.zip', 'C:\Windows\Temp\axis2-1.6.0-war.zip')" <NUL
cmd /c ""C:\Program Files\7-Zip\7z.exe" x "C:\Windows\Temp\axis2-1.6.0-war.zip" -oC:\axis2"
copy /Y C:\axis2\axis2.war "%CATALINA_HOME%\webapps"
rd /s /q C:\axis2
