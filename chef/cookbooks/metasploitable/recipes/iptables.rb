#
# Cookbook:: metasploitable
# Recipe:: iptables
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

execute "apt-get update" do
  command "apt-get update"
end

bash 'setup for knockd, used for flag' do
  code <<-EOH
    iptables -A FORWARD 1 -p tcp -m tcp --dport 8989 -j DROP
    iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    iptables -A INPUT -p tcp --dport 80 -j ACCEPT
    iptables -A INPUT -j DROP
  EOH
end

package 'iptables-persistent' do
  action :install
end

service 'iptables-persistent' do
  action [:enable, :start]
end

