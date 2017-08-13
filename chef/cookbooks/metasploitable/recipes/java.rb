#
# Cookbook:: metasploitable
# Recipe:: java
#
# Copyright:: 2017, The Authors, All Rights Reserved.

execute 'Install Java' do
  command 'choco install -y javaruntime-platformspecific'
  action :run
end
