#
# Cookbook:: metasploitable
# Recipe:: cups
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

include_recipe 'iptables::default'

package 'cups' do
  action :install
end

cookbook_file '/etc/cups/cupsd.conf' do
  source 'cups/cupsd.conf'
  mode '0644'
end

iptables_rule '1_cups' do
  lines "-A INPUT -p tcp --dport 631 -j ACCEPT"
end

service 'cups' do
  action [:enable, :restart]
end
