#
# Cookbook:: metasploitable
# Recipe:: sshd
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

cookbook_file '/etc/ssh/sshd_config' do
  source 'sshd/sshd_config'
  mode '0644'
end

service 'ssh' do
  action :restart
end
