#
# Cookbook:: metasploitable
# Recipe:: mysql
#
# Copyright:: 2017, The Authors, All Rights Reserved.

mysql_client 'default' do
  action :create
end

mysql_service 'default' do
  initial_root_password 'sploitme'
  bind_address '0.0.0.0'
  port '3306'
  action [:create, :start]
end