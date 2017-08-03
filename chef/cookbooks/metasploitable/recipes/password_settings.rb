#
# Cookbook:: metasploitable
# Recipe:: password_settings
#
# Copyright:: 2017, The Authors, All Rights Reserved.

cookbook_file 'C:\Windows\Temp\secconfig.cfg' do
  source 'security_settings/secconfig.cfg'
  action :create
end

batch 'Password Settings' do
  code 'secedit.exe /configure /db %windir%\securitynew.sdb /cfg C:\Windows\Temp\secconfig.cfg /areas SECURITYPOLICY'
end
