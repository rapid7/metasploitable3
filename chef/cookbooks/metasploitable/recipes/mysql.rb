#
# Cookbook:: metasploitable
# Recipe:: mysql
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

mysql_service 'default' do
  initial_root_password "#{node[:mysql][:root_password]}"
  bind_address '0.0.0.0'
  port '3306'
  action [:create, :start]
end

mysql_client 'default' do
    action :create
end
