#
# Cookbook:: metasploitable
# Recipe:: jenkins
#
# Copyright:: 2017, The Authors, All Rights Reserved.

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
