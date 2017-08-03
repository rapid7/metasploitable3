#
# Cookbook:: metasploitable
# Recipe:: apache_struts
#
# Copyright:: 2017, The Authors, All Rights Reserved.

file 'C:\Program Files\Apache Software Foundation\tomcat\apache-tomcat-8.0.33\conf\tomcat-users.xml' do
  action :delete
end

cookbook_file 'C:\Program Files\Apache Software Foundation\tomcat\apache-tomcat-8.0.33\conf\tomcat-users.xml' do
  source 'apache_struts/tomcat-users.xml'
  action :create
end

cookbook_file 'C:\Program Files\Apache Software Foundation\tomcat\apache-tomcat-8.0.33\conf\server.xml' do
  source 'apache_struts/server.xml'
  action :create
end

windows_service 'Tomcat8' do
  action [:enable, :start]
  startup_type :automatic
end

cookbook_file 'C:\Program Files\Apache Software Foundation\tomcat\apache-tomcat-8.0.33\webapps\struts2-rest-showcase.war' do
  source 'apache_struts/struts2-rest-showcase.war'
  action :create
end
