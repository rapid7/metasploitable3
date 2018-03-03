#
# Cookbook:: metasploitable
# Recipe:: cleaner
#
# Copyright:: 2017, The Authors, All Rights Reserved.

directory 'C:\vagrant' do
  recursive true
  action :delete
end
