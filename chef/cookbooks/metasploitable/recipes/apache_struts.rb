#
# Cookbook:: metasploitable
# Recipe:: apache_struts
#
# Copyright:: 2017, The Authors, All Rights Reserved.

file "\%CATALINA_HOME\%\\conf\\tomcat-users.xml" do
  action :delete
end

batch 'Copy files' do
  code <<-EOH
    copy C:\\vagrant\\resources\\apache_struts\\tomcat-users.xml "%CATALINA_HOME%\\conf\\tomcat-users.xml"
    copy C:\\vagrant\\resources\\apache_struts\\server.xml "%CATALINA_HOME%\\conf"
  EOH
end

windows_service 'Tomcat8' do
  action [:enable, :start]
  startup_type :automatic
end

execute 'Copy struts webapp' do
  command "copy C:\\vagrant\\resources\\apache_struts\\struts2-rest-showcase.war \"\%CATALINA_HOME%\\webapps\\\""
  action :run
end
