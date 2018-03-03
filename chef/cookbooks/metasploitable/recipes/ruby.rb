#
# Cookbook:: metasploitable
# Recipe:: ruby
#
# Copyright:: 2017, The Authors, All Rights Reserved.

chocolatey_package 'ruby' do
  version '2.3.3'
  action :install
end

execute 'refreshenv' do
  action :run
end
