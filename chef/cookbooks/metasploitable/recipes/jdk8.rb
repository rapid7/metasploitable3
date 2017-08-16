#
# Cookbook:: metasploitable
# Recipe:: jdk8
#
# Copyright:: 2017, The Authors, All Rights Reserved.

chocolatey_package 'jdk8' do
  action :install
end

execute 'Refresh environment' do
  command 'refreshenv'
  action :run
end
