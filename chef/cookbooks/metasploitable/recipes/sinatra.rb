#
# Cookbook:: sinatra
# Recipe:: sinatra
#
# Copyright:: 2017, Rapid7, All Rights Reserved.
#
#

include_recipe 'metasploitable::sinatra'

apt_repository 'rvm' do
  uri 'ppa:rael-gc/rvm'
end

package 'rvm'

bash 'run rvm.sh' do
  code <<-EOH
  source /etc/profile.d/rvm.sh
  rvmsudo rvm install ruby-2.3.1
  rvm --default use 2.3.1
  gem install bundler
  EOH
end

directory '/opt/sinatra' do
  mode '0777'
end

['Gemfile', 'README.txt', 'check.rb', 'poc.rb', 'start.rb'].each do |fname|
  cookbook_file "/opt/sinatra/#{fname}" do
    source "sinatra/#{fname}"
    mode '0777'
  end
end

bash 'bundle install sinatra' do
  code <<-EOH
  cd /opt/sinatra
  bundle install
  EOH
end

cookbook_file '/etc/init.d/sinatra' do
  source 'sinatra/sinatra.sh'
  mode '0777'
end

service 'sinatra' do
  action [:enable, :start]
end
