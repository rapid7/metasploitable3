#
# Cookbook:: metasploitable
# Recipe:: jenkins
#
# Copyright:: 2017, The Authors, All Rights Reserved.

directory 'C:\Program Files\jenkins' do
  action :create
end

cookbook_file "\%ProgramFiles\%\\jenkins\\jenkins.war" do
  source 'resources\jenkins\jenkins.war'
  action :create
end

cookbook_file "\%ProgramFiles\%\\jenkins\\jenkins.exe" do
  source 'resources\jenkins\jenkins.exe'
  action :create
end

execute "\"C:\\Program Files\\jenkins\\jenkins.exe\" -Service Install" do
  action :run
end

windows_service 'jenkins' do
  action [:enable, :start]
  startup_type :automatic
end

