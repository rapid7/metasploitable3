#
# Cookbook:: metasploitable
# Recipe:: mysql
#
# Copyright:: 2017, The Authors, All Rights Reserved.

file 'C:\wamp\bin\mysql\mysql5.5.20\my.ini' do
  content IO.read('C:\vagrant\resources\mysql\my.ini')
end

execute 'Update MySQL Permissions' do
  command '"C:\wamp\bin\mysql\mysql5.5.20\bin\mysql.exe" -u root --password=""  wordpress < "C:\Vagrant\resources\mysql\update_mysql_permissions.sql"' 
  action :run
end

windows_service 'wampmysqld' do
  action :restart
end
