net stop wampapache
mkdir C:\wamp\www\uploads\
copy /Y C:\Vagrant\resources\webdav\httpd.conf C:\wamp\bin\apache\Apache2.2.21\conf\
copy /Y C:\Vagrant\resources\webdav\httpd-dav.conf C:\wamp\bin\apache\Apache2.2.21\conf\extra\
net start wampapache
