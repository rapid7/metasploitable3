#
# Cookbook:: metasploitable
# Recipe:: password_settings
#
# Copyright:: 2017, The Authors, All Rights Reserved.

batch 'Password Settings' do
  code 'secedit.exe /configure /db %windir%\securitynew.sdb /cfg C:\vagrant\resources\security_settings\secconfig.cfg /areas SECURITYPOLICY'
end
