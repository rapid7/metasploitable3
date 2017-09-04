#
# Cookbook:: metasploitable
# Recipe:: configure_firewall
#
# Copyright:: 2017, The Authors, All Rights Reserved.

execute 'Closed port 445 for SMB' do
  command 'netsh advfirewall firewall add rule name="Closed port 445 for SMB" dir=in action=block protocol=TCP localport=445'
  action :run
end

execute 'Closed port 139 for NetBIOS' do
  command 'netsh advfirewall firewall add rule name="Closed port 139 for NetBIOS" dir=in action=block protocol=TCP localport=139'
  action :run
end

execute 'Closed port 135 for NetBIOS' do
  command 'netsh advfirewall firewall add rule name="Closed port 135 for NetBIOS" dir=in action=block protocol=TCP localport=135'
  action :run
end

execute 'Closed Port 3389 for Remote Desktop' do
  command 'netsh advfirewall firewall add rule name="Closed Port 3389 for Remote Desktop" dir=in action=block protocol=TCP localport=3389'
  action :run
end

execute 'Closed Port 3306 for MySQL' do
  command 'netsh advfirewall firewall add rule name="Closed Port 3306 for MySQL" dir=in action=block protocol=TCP localport=3306'
  action :run
end