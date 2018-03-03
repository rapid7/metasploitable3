#
# Cookbook:: metasploitable
# Recipe:: backdoors
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'metasploitable::iis'
include_recipe 'metasploitable::wamp'

cookbook_file 'C:\inetpub\wwwroot\caidao.asp' do
  source 'backdoors/caidao.asp'
  action :create
end

cookbook_file 'C:\wamp\www\mma.php' do
  source 'backdoors/mma.php'
  action :create
end

cookbook_file 'C:\wamp\www\meterpreter.php' do
  source 'backdoors/meterpreter.php'
  action :create
end
