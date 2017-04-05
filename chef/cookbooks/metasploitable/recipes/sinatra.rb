#
# Cookbook:: sinatra
# Recipe:: sinatra
#
# Copyright:: 2017, Rapid7, All Rights Reserved.
#
#

include_recipe 'metasploitable::sinatra'

apt_repository 'rvm' do
  uri 'ppa:brightbox/ruby-ng'
end

package 'ruby2.3'

package 'bundler'

directory '/opt/sinatra' do
  mode '0777'
end

['Gemfile', 'README.txt', 'check.rb', 'poc.rb', 'start.sh', 'server.rb'].each do |fname|
  cookbook_file "/opt/sinatra/#{fname}" do
    source "sinatra/#{fname}"
    mode '0777'
  end
end

cookbook_file '/etc/init/sinatra.conf' do
  source 'sinatra/sinatra.conf'
  mode '0777'
end

service 'sinatra' do
  supports restart: false, start: true, reload: false, status: false
  action [:enable, :start]
end
