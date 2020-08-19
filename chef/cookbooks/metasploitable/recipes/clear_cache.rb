#
# Cookbook:: metasploitable
# Recipe:: clear_cache
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

# 'clear cache and backup that might contain sensitive information' do
directory '/var/chef' do
  action :delete
  recursive true
end