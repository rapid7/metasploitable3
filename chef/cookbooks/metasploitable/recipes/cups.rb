#
# Cookbook:: metasploitable
# Recipe:: cups
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

execute 'apt-get update' do
  command 'apt-get update'
end

package 'cups' do
  action :install
end

cookbook_file '/etc/cups/cupsd.conf' do
  source 'cups/cupsd.conf'
  mode '0644'
end

service 'cups' do
  action [:enable, :start]
end
