#
# Cookbook:: metasploitable
# Recipe:: mysql
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'metasploitable::wamp'
include_recipe 'metasploitable::wordpress'

cookbook_file 'C:\wamp\bin\mysql\mysql5.5.20\my.ini' do
  source 'mysql/my.ini'
  action :create
end

cookbook_file 'C:\Windows\Temp\update_mysql_permissions.sql' do
  source 'mysql/update_mysql_permissions.sql'
  action :create
end

execute 'Update MySQL Permissions' do
  command '"C:\wamp\bin\mysql\mysql5.5.20\bin\mysql.exe" -u root --password=""  wordpress < "C:\Windows\Temp\update_mysql_permissions.sql"' 
  action :run
end

windows_service 'wampmysqld' do
  action :restart
end
