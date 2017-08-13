#
# Cookbook:: metasploitable
# Recipe:: tomcat
#
# Copyright:: 2017, The Authors, All Rights Reserved.

execute 'Install Tomcat' do
  command 'choco install -y tomcat --version 8.0.33'
  action :run
end
