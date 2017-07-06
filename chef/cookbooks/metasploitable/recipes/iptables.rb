#
# Cookbook:: metasploitable
# Recipe:: iptables
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

execute "apt-get update" do
  command "apt-get update"
end

bash 'setup for knockd, used for flag' do
  code 'iptables -A FORWARD 1 -p tcp -m tcp --dport 8989 -j DROP'
  code 'iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT'
  node[:metasploitable][:ports].keys.each do |service|
    code "iptables -A INPUT -p tcp --dport #{node[:metasploitable][:ports][service]} -j ACCEPT"
  end
  code 'iptables -A INPUT -j DROP'
end

package 'iptables-persistent' do
  action :install
end

service 'iptables-persistent' do
  action [:enable, :start]
end

