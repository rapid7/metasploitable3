#
# Cookbook:: metasploitable
# Recipe:: jdk8
#
# Copyright:: 2017, The Authors, All Rights Reserved.

execute 'Install JDK 8' do
  command 'choco install -y jdk8'
  action :run
end

execute 'Refresh environment' do
  command 'refreshenv'
  action :run
end
