#
# Cookbook:: metasploitable
# Recipe:: webdav
#
# Copyright:: 2017, The Authors, All Rights Reserved.

windows_service 'wampapache' do
  action :stop
end

directory 'C:\wamp\www\uploads' do
  action :create
end

file 'C:\wamp\alias\httpd-dav.conf' do
  content IO.read('C:\vagrant\resources\webdav\httpd-dav.conf')
  action :create
end

windows_service 'wampapache' do
  action :start
end
