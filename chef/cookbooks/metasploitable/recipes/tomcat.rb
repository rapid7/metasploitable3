#
# Cookbook:: metasploitable
# Recipe:: tomcat
#
# Copyright:: 2017, The Authors, All Rights Reserved.

chocolatey_package 'tomcat' do
  version '8.0.33'
  action :install
end
