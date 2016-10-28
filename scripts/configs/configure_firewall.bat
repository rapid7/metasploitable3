netsh advfirewall firewall add rule name="Open Port 8484 for Jenkins" dir=in action=allow protocol=TCP localport=8484
netsh advfirewall firewall add rule name="Open Port 8282 for Apache Struts" dir=in action=allow protocol=TCP localport=8282
netsh advfirewall firewall add rule name="Open Port 80 for IIS" dir=in action=allow protocol=TCP localport=80
netsh advfirewall firewall add rule name="Open Port 4848 for GlassFish" dir=in action=allow protocol=TCP localport=4848
netsh advfirewall firewall add rule name="Open Port 8080 for GlassFish" dir=in action=allow protocol=TCP localport=8080
netsh advfirewall firewall add rule name="Open Port 8585 for Wordpress and phpMyAdmin" dir=in action=allow protocol=TCP localport=8585
netsh advfirewall firewall add rule name="Java 1.6 java.exe" dir=in action=allow program="C:\openjdk6\openjdk-1.6.0-unofficial-b27-windows-amd64\jre\bin\java.exe" enable=yes
netsh advfirewall firewall add rule name="Open Port 3000 for Rails Server" dir=in action=allow protocol=TCP localport=3000
netsh advfirewall firewall add rule name="Open Port 8020 for ManageEngine Desktop Central" dir=in action=allow protocol=TCP localport=8020
netsh advfirewall firewall add rule name="Open Port 8383 for ManageEngine Desktop Central" dir=in action=allow protocol=TCP localport=8383
netsh advfirewall firewall add rule name="Open Port 8022 for ManageEngine Desktop Central" dir=in action=allow protocol=TCP localport=8022
netsh advfirewall firewall add rule name="Open Port 161 for SNMP" dir=in action=allow protocol=UDP localport=161
netsh advfirewall firewall add rule name="Closed port 445 for SMB" dir=in action=block protocol=TCP localport=445
netsh advfirewall firewall add rule name="Closed port 139 for NetBIOS" dir=in action=block protocol=TCP localport=139
netsh advfirewall firewall add rule name="Closed port 135 for NetBIOS" dir=in action=block protocol=TCP localport=135
netsh advfirewall firewall add rule name="Closed Port 3389 for Remote Desktop" dir=in action=block protocol=TCP localport=3389
netsh advfirewall firewall add rule name="Closed Port 3306 for MySQL" dir=in action=block protocol=TCP localport=3306
