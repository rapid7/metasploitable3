#
# Cookbook:: metasploitable
# Recipe:: vcredist
#
# Copyright:: 2017, The Authors, All Rights Reserved.

chocolatey_package 'vcredist2008' do
  action :install
end
