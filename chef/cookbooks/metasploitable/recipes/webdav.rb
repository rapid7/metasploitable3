#
# Cookbook:: metasploitable
# Recipe:: webdav
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'metasploitable::wamp'

windows_service 'wampapache' do
  action :stop
end

directory 'C:\wamp\www\uploads' do
  action :create
end

cookbook_file 'C:\wamp\alias\httpd-dav.conf' do
  source 'webdav/httpd-dav.conf'
  action :create
end

windows_service 'wampapache' do
  action :start
end
