#
# Cookbook:: metasploitable
# Recipe:: vcredist
#
# Copyright:: 2017, The Authors, All Rights Reserved.

execute 'Install VCRedist' do
  command 'choco install vcredist2008'
  action :run
end
