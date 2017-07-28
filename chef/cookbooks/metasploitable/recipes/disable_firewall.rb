#
# Cookbook:: metasploitable
# Recipe:: disable_firewall
#
# Copyright:: 2017, The Authors, All Rights Reserved.

batch 'Disable Firewall' do
  code 'netsh advfirewall set allprofiles state off'
end
