#
# Cookbook:: metasploitable
# Recipe:: iptables
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

execute "apt-get update" do
  command "apt-get update"
end

bash 'setup for knockd, used for flag' do
  code_to_execute = ""
  code_to_execute << "iptables -A FORWARD 1 -p tcp -m tcp --dport 8989 -j DROP\n"
  code_to_execute << "iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT\n"
  node[:metasploitable][:ports].keys.each do |service|
    code_to_execute << "iptables -A INPUT -p tcp --dport #{node[:metasploitable][:ports][service.to_sym]} -j ACCEPT\n"
  end
  code_to_execute << "iptables -A INPUT -p tcp --dport 22 -j ACCEPT\n"
  code_to_execute << "iptables -A INPUT -p icmp -j ACCEPT\n"
  code_to_execute << "iptables -A INPUT -j DROP\n"
  code code_to_execute
end

package 'iptables-persistent' do
  action :install
end

service 'iptables-persistent' do
  action [:enable, :start]
end

