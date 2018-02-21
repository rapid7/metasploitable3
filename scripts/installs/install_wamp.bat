copy /Y "C:\vagrant\resources\wamp\wampserver2.2d-x64.exe" "C:\Windows\Temp\wampserver2.2.d-x64.exe"
C:\Windows\Temp\wampserver2.2.d-x64.exe /verysilent
copy /Y "C:\vagrant\resources\wamp\httpd.conf" "C:\wamp\bin\apache\Apache2.2.21\conf\httpd.conf"
copy /Y "C:\vagrant\resources\wamp\phpmyadmin.conf" "C:\wamp\alias\phpmyadmin.conf"
sc config wampapache start= auto
sc config wampmysqld start= auto
icacls "C:\wamp" /grant "NT Authority\LOCAL SERVICE:(OI)(CI)F" /T
sc config wampapache obj= "NT Authority\LOCAL SERVICE"
