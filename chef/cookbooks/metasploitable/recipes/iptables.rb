#
# Cookbook:: metasploitable
# Recipe:: iptables
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

include_recipe 'iptables::default'

iptables_rule '00_established' do
  lines '-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT'
end

iptables_rule '00_lo_allow_in' do
  lines '-I INPUT -i lo -j ACCEPT'
end

iptables_rule '00_lo_allow_out' do
  lines '-I OUTPUT -o lo -j ACCEPT'
end

iptables_rule '01_ssh' do
  lines "-A INPUT -p tcp --dport 22 -j ACCEPT"
end

iptables_rule '999_drop_all' do
  lines '-A INPUT -j DROP'
end
