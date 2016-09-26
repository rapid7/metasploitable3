REM The below command was temporarily working to successfully download the installer but is now giving a 404.
REM Switching to copying the file from the repo until a reliable host can be found.
REM http://sourceforge.mirrorservice.org/w/wa/wampserver/WampServer%202/WampServer%202.2/wampserver2.2d-x64.exe
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('http://sourceforge.mirrorservice.org/w/wa/wampserver/WampServer 2/WampServer 2.2/wampserver2.2d-x64.exe', 'C:\Windows\Temp\wampserver2.2.d-x64.exe')" <NUL
copy /Y "C:\vagrant\resources\wamp\wampserver2.2d-x64.exe" "C:\Windows\Temp\wampserver2.2.d-x64.exe"
C:\Windows\Temp\wampserver2.2.d-x64.exe /verysilent
copy /Y "C:\vagrant\resources\wamp\httpd.conf" "C:\wamp\bin\apache\Apache2.2.21\conf\httpd.conf"
copy /Y "C:\vagrant\resources\wamp\phpmyadmin.conf" "C:\wamp\alias\phpmyadmin.conf"
sc config wampapache start= auto
sc config wampmysqld start= auto