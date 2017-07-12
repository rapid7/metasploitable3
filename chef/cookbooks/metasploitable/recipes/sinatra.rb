#
# Cookbook:: metasploitable
# Recipe:: sinatra
#
# Copyright:: 2017, Rapid7, All Rights Reserved.
#
#

include_recipe 'metasploitable::sinatra'
include_recipe 'metasploitable::ruby23'

directory '/opt/sinatra' do
  mode '0777'
end

directory '/var/opt/sinatra' do
  mode '0777'
end

['Gemfile', 'server'].each do |fname|
  cookbook_file "/opt/sinatra/#{fname}" do
    source "sinatra/#{fname}"
    mode '0777'
  end
end

cookbook_file '/var/opt/sinatra/start.sh' do
  source 'sinatra/start.sh'
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
