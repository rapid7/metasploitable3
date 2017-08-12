#
# Cookbook:: metasploitable
# Recipe:: 7zip
#
# Copyright:: 2017, The Authors, All Rights Reserved.

execute 'Install 7zip' do
  command 'choco install -y 7zip'
  action :run
end
