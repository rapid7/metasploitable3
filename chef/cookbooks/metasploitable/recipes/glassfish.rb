#
# Cookbook:: metasploitable
# Recipe:: glassfish
#
# Copyright:: 2017, The Authors, All Rights Reserved.

directory 'C:\\glassfish' do
  action :create
end

powershell_script 'Download GlassFish' do
  code "(New-Object System.Net.WebClient).DownloadFile('http://download.java.net/glassfish/4.0/release/glassfish-4.0.zip', 'C:\\Windows\\Temp\\glassfish4.zip')" 
end

execute 'Copy files' do
  command '"C:\\Program Files\\7-Zip\\7z.exe" -y x "C:\\Windows\\Temp\\glassfish4.zip" -oC:\\glassfish'
  action :run
end

cookbook_file 'C:\glassfish\glassfish4\glassfish\domains\domain1\config\admin-keyfile' do
  source 'glassfish\admin-keyfile'
  action :create
end

cookbook_file 'C:\glassfish\glassfish4\glassfish\domains\domain1\config\domain.xml' do
  source 'glassfish\domain.xml'
  action :create
end

execute "C:\\glassfish\\glassfish4\\bin\\asadmin.bat create-service domain1" do
  action :run
end

windows_service 'domain1' do
  action [:enable, :start]
end

powershell_script 'Sleep for 10 seconds' do
  guard_interpreter :powershell_script
  code 'Start-Sleep -s 10'
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
