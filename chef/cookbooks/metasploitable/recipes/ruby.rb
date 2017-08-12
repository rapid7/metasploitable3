#
# Cookbook:: metasploitable
# Recipe:: ruby
#
# Copyright:: 2017, The Authors, All Rights Reserved.

execute 'Install Ruby' do
  command 'choco install -y ruby --version 2.3.3'
  action :run
end

execute 'refreshenv' do
  action :run
end
