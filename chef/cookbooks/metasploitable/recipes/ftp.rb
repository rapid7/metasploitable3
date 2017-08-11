#
# Cookbook:: metasploitable
# Recipe:: ftp
#
# Copyright:: 2017, The Authors, All Rights Reserved.

cookbook_file 'C:\Windows\System32\inetsrv\config\applicationHost.config' do
  source 'iis/applicationHost.config'
  action :create
end
