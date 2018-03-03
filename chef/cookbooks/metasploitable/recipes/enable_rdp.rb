#
# Cookbook:: metasploitable
# Recipe:: enable_rdp
#
# Copyright:: 2017, The Authors, All Rights Reserved.

batch 'Enable RDP' do
  code "netsh advfirewall firewall add rule name=\"Open Port 3389\" dir=in action=allow protocol=TCP localport=3389"
end

registry_key "HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Terminal Server" do
  values [{:name => "fDenyTSConnections", :type => :dword, :data => 0}]
  action :create
end
