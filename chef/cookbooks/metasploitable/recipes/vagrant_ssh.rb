#
# Cookbook:: metasploitable
# Recipe:: vagrant_ssh
#
# Copyright:: 2017, The Authors, All Rights Reserved.

directory 'C:\\Users\\vagrant\\.ssh' do
  action :create
end

directory 'C:\\Users\\vagrant\\.ssh\\authorized_keys' do
  action :create
end

remote_file 'C:\Users\vagrant\.ssh\authorized_keys\vagrant.pub' do
  source 'http://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub'
  action :create
end