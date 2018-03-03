#
# Cookbook:: metasploitable
# Recipe:: snmp
#
# Copyright:: 2017, The Authors, All Rights Reserved.

batch 'Install SNMP' do
  code 'start /w PKGMGR.EXE /quiet /norestart /iu:SNMP'
end

registry_key 'HKLM\SYSTEM\ControlSet001\services\SNMP\Parameters\PermittedManagers' do
  action :delete
end

registry_key 'HKLM\SYSTEM\ControlSet001\services\SNMP\Parameters' do
  values [{:name => 'EnableAuthenticationTraps', :type => :dword, :data => 0}]
  action :create
end

registry_key 'HKLM\SYSTEM\ControlSet001\services\SNMP\Parameters\ValidCommunities' do
  values [{:name => 'public', :type => :dword, :data => 4}]
  action :create
end

execute 'Add firewall rule' do
  command 'netsh advfirewall firewall add rule name="Open Port 161 for SNMP" dir=in action=allow protocol=UDP localport=161'
  action :run
end