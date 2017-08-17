#
# Cookbook:: metasploitable
# Recipe:: wordpress
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'metasploitable::7zip'
include_recipe 'metasploitable::vcredist'

directory 'C:\Program Files\wordpress' do
  action :create
end

cookbook_file 'C:\Program Files\wordpress\update_ip.ps1' do
  source 'wordpress/update_ip.ps1'
  action :create
end

cookbook_file 'C:\Windows\temp\wordpress.zip' do
  source 'wordpress/wordpress.zip'
  action :create
end

execute 'Extract wordpress' do
  command '"C:\Program Files\7-Zip\7z.exe" x C:\Windows\temp\wordpress.zip -oC:\wamp\www\\'
  action :run
end

execute 'Create database' do
  command 'C:\wamp\bin\mysql\mysql5.5.20\bin\mysql.exe -u root --password=""  -e "create database wordpress;"'
  action :run
end

cookbook_file 'C:\Windows\temp\wordpress.sql' do
  source 'wordpress/wordpress.sql'
  action :create
end

execute 'Copy DB' do
  command 'C:\wamp\bin\mysql\mysql5.5.20\bin\mysql.exe -u root --password=""  wordpress < "C:\Windows\temp\wordpress.sql"'
  action :run
end

execute 'Update IP' do
  command 'schtasks /create /tn "update_wp_db" /tr "\"cmd.exe\" /c powershell -File \"C:\Program Files\wordpress\update_ip.ps1\"" /sc onstart /NP /ru "SYSTEM"'
  action :run
end

powershell_script "Updates IP" do
  code '"C:\Program Files\wordpress\update_ip.ps1"'
  action :run
end

batch 'Set attributes' do
  code 'attrib -r +s C:\wamp\www\wordpress'
end
