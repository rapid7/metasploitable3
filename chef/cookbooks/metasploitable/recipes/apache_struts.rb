#
# Cookbook:: metasploitable
# Recipe:: apache_struts
#
# Copyright:: 2017, The Authors, All Rights Reserved.

file "\%CATALINA_HOME\%\\conf\\tomcat-users.xml" do
  action :delete
end

cookbook_file "\%CATALINA_HOME\%\\conf\\tomcat-users.xml" do
  source 'apache_struts\tomcat-users.xml'
  action :create
end

cookbook_file "\%CATALINA_HOME\%\\conf\\server.xml" do
  source 'apache_struts\server.xml'
  action :create
end

windows_service 'Tomcat8' do
  action [:enable, :start]
  startup_type :automatic
end

execute 'Copy struts webapp' do
  command "copy C:\\vagrant\\resources\\apache_struts\\struts2-rest-showcase.war \"\%CATALINA_HOME%\\webapps\\\""
  action :run
end
