#
# Cookbook:: metasploitable
# Recipe:: mysql
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

execute "apt-get update" do
  command "apt-get update"
end

mysql_service 'default' do
  initial_root_password 'sploitme'
  bind_address '0.0.0.0'
  port '3306'
  action [:create, :start]
end
