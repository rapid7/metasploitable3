#
# Cookbook:: metasploitable
# Recipe:: axis2
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'metasploitable::tomcat'

remote_file 'C:\Windows\Temp\axis2-1.6.0-war.zip' do
  source 'http://archive.apache.org/dist/axis/axis2/java/core/1.6.0/axis2-1.6.0-war.zip'
  action :create
end

execute 'Extracting files' do
  command '"C:\Program Files\7-Zip\7z.exe" x "C:\Windows\Temp\axis2-1.6.0-war.zip" -oC:\axis2'
  action :run
end

execute 'Copy files' do
  command 'copy /Y C:\axis2\axis2.war "C:\Program Files\Apache Software Foundation\tomcat\apache-tomcat-8.0.33\webapps\axis2.war"'
  action :run
end

directory 'C:\axis2' do
  recursive true
  action :delete
end
