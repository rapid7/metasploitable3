#
# Cookbook:: metasploitable
# Recipe:: flags
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

directory '/opt/knock_knock' do
  mode 0700
end

cookbook_file '/opt/knock_knock/five_of_diamonds' do
  source 'flags/five_of_diamonds'
  mode 0700
end

cookbook_file '/etc/init.d/five_of_diamonds_srv' do
  source 'flags/five_of_diamonds_srv'
  mode '760'
end

service 'five_of_diamonds_srv' do
  action [:enable, :start]
end
