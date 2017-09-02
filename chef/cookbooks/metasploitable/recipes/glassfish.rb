#
# Cookbook:: metasploitable
# Recipe:: glassfish
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'metasploitable::7zip'
include_recipe 'metasploitable::jdk8'

directory 'C:\\glassfish' do
  action :create
end

remote_file 'C:\Windows\Temp\glassfish4.zip' do
  source 'http://download.java.net/glassfish/4.0/release/glassfish-4.0.zip'
  action :create
end

execute 'Copy files' do
  command '"C:\\Program Files\\7-Zip\\7z.exe" -y x "C:\\Windows\\Temp\\glassfish4.zip" -oC:\\glassfish'
  action :run
end

cookbook_file 'C:\glassfish\glassfish4\glassfish\domains\domain1\config\admin-keyfile' do
  source 'glassfish/admin-keyfile'
  action :create
end

cookbook_file 'C:\glassfish\glassfish4\glassfish\domains\domain1\config\domain.xml' do
  source 'glassfish/domain.xml'
  action :create
end

execute 'C:\glassfish\glassfish4\bin\asadmin.bat create-service domain1' do
  action :run
  environment ({'Path' => 'C:\Program Files\Java\jdk1.8.0_144\bin'})
end

windows_service 'domain1' do
  action [:enable, :start]
end

ruby_block 'Sleep for 15 secs' do
  block do
    sleep(15)
  end
  action :run
end

windows_service 'domain1' do
  action :stop
end

batch 'Configure files' do
  code <<-EOH
    icacls "C:\\glassfish" /grant "NT Authority\\LOCAL SERVICE:(OI)(CI)F" /T
    sc config "domain1" obj= "NT Authority\\LOCAL SERVICE"
  EOH
end
