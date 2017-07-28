#
# Cookbook:: metasploitable
# Recipe:: disable_auto_logon
#
# Copyright:: 2017, The Authors, All Rights Reserved.

batch 'unzip_and_move_ruby' do
  code <<-EOH
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /d 0 /f
    EOH
end
