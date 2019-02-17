#
# Cookbook:: metasploitable
# Recipe:: knockd
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

package 'knockd' do
  action :install
end

template '/etc/knockd.conf' do
  source 'knockd/knockd.conf.erb'
  mode '0600'
end

cookbook_file '/etc/default/knockd' do
  source 'knockd/knockd'
  mode '0600'
end

execute 'remove_carriage_returns' do
    command "sed -i -e 's/\r//g' /etc/default/knockd"
end

service 'knockd' do
  action [:enable, :start]
end
