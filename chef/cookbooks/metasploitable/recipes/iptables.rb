#
# Cookbook:: metasploitable
# Recipe:: iptables
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

iptables_rule 'established' do
  lines '-I INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT'
end

node[:metasploitable][:ports].keys.each do |service|
  iptables_rule service do
    lines "-I INPUT -p tcp --dport #{node[:metasploitable][:ports][service.to_sym]} -j ACCEPT"
  end
end

iptables_rule 'drop_all' do
  lines '-A INPUT -j DROP'
end



