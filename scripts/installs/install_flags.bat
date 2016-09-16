copy C:\vagrant\resources\flags\six_of_diamonds.zip C:\inetpub\wwwroot

copy C:\vagrant\resources\flags\jack_of_clubs.PNG C:\jack_of_clubs
cacls "C:\jack_of_clubs" /t /e /g SYSTEM:f
cacls "C:\jack_of_clubs" /R Administrators /E
cacls "C:\jack_of_clubs" /R Users /E

copy C:\vagrant\resources\flags\queen_of_hearts.JPG C:\
cacls "C:\queen_of_hearts.JPG" /t /e /g SYSTEM:f
cacls "C:\queen_of_hearts.JPG" /R Administrators /E
cacls "C:\queen_of_hearts.JPG" /R USERS /E

copy C:\vagrant\resources\flags\joker.html C:\inetpub\wwwroot\index.html
copy C:\vagrant\resources\flags\hahaha.jpg C:\inetpub\wwwroot
del C:\inetpub\wwwroot\iisstart.htm