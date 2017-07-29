#
# Cookbook:: metasploitable
# Recipe:: wordpress
#
# Copyright:: 2017, The Authors, All Rights Reserved.

directory "C:\\Program Files\\wordpress" do
  action :create
end

execute 'Copy IP updater' do
  command "copy C:\\vagrant\\resources\\wordpress\\update_ip.ps1 \"C:\\Program Files\\wordpress\\update_ip.ps1\""
end

execute 'Extract wordpress' do
  command "\"C:\\Program Files\\7-Zip\\7z.exe\" x C:\\vagrant\\resources\\wordpress\\wordpress.zip -oC:\\wamp\\www\\"
end

execute 'C:\wamp\bin\mysql\mysql5.5.20\bin\mysql.exe -u root --password=""  -e "create database wordpress;"' do
  action :run
end

execute 'C:\wamp\bin\mysql\mysql5.5.20\bin\mysql.exe -u root --password=""  wordpress < "C:\Vagrant\resources\wordpress\wordpress.sql"' do
  action :run
end

execute 'Update IP' do
  command 'schtasks /create /tn "update_wp_db" /tr "\"cmd.exe\" /c powershell -File \"C:\Program Files\wordpress\update_ip.ps1\"" /sc onstart /NP /ru "SYSTEM"'
  action :run
end

powershell_script "Updates IP" do
  code "& 'C:\\Program Files\\wordpress\\update_ip.ps1'"
end

batch 'Set attributes' do
  code 'attrib -r +s C:\wamp\www\wordpress'
end

