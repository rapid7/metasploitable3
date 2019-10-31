#
# Cookbook:: metasploitable
# Recipe:: sinatra
#
# Copyright:: 2017, Rapid7, All Rights Reserved.
#
#

include_recipe 'metasploitable::sinatra'
include_recipe 'metasploitable::ruby23'
include_recipe 'iptables::default'

iptables_rule '1_sinatra' do
  lines "-A INPUT -p tcp --dport 8181 -j ACCEPT"
end

server_path = node['ec2'] ? 'aws' : 'virtualbox'

directory '/opt/sinatra' do
  mode '0777'
end

directory '/var/opt/sinatra' do
  mode '0777'
end

cookbook_file '/opt/sinatra/Gemfile' do
  source 'sinatra/Gemfile'
  mode '0777'
end

cookbook_file '/opt/sinatra/server' do
  source "sinatra/#{server_path}/loader"
  mode '0777'
end

cookbook_file '/etc/init/sinatra.conf' do
  source 'sinatra/sinatra.conf'
  mode '0777'
end

service 'sinatra' do
  supports restart: false, start: true, reload: false, status: false
  action [:enable, :start]
end
