#
# Cookbook:: metasploitable
# Recipe:: apache_struts
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'metasploitable::tomcat'
include_recipe 'metasploitable::java'

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

execute 'Update firewall rule' do
  command 'netsh advfirewall firewall add rule name="Open Port 8282 for Apache Struts" dir=in action=allow protocol=TCP localport=8282'
  action :run
end