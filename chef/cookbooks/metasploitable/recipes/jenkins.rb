#
# Cookbook:: metasploitable
# Recipe:: jenkins
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'metasploitable::java'
include_recipe 'metasploitable::jdk8'

directory 'C:\Program Files\jenkins' do
  action :create
end

cookbook_file 'C:\Program Files\jenkins\jenkins.war' do
  source 'jenkins/jenkins.war'
  action :create
end

cookbook_file 'C:\Program Files\jenkins\jenkins.exe' do
  source 'jenkins/jenkins.exe'
  action :create
end

execute 'Install Jenkins' do
  command '"C:\Program Files\jenkins\jenkins.exe" -Service Install'
  action :run
end

windows_service 'jenkins' do
  action [:enable, :start]
  startup_type :automatic
end

execute 'Update firewall rule' do
  command 'netsh advfirewall firewall add rule name="Open Port 8484 for Jenkins" dir=in action=allow protocol=TCP localport=8484'
  action :run
end