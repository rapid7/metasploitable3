net stop wampapache
mkdir C:\wamp\www\uploads\
copy /Y C:\Vagrant\resources\webdav\httpd-dav.conf C:\wamp\alias
net start wampapache
