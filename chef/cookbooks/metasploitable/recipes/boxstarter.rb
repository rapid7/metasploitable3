#
# Cookbook:: metasploitable
# Recipe:: boxstarter
#
# Copyright:: 2017, The Authors, All Rights Reserved.

chocolatey_package 'BoxStarter' do
  action :install
end