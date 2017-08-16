#
# Cookbook:: metasploitable
# Recipe:: java
#
# Copyright:: 2017, The Authors, All Rights Reserved.

chocolatey_package 'javaruntime-platformspecific' do
  action :install
end
