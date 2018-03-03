#
# Cookbook:: metasploitable
# Recipe:: rails
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'metasploitable::devkit'

cookbook_file 'C:\Users\vagrant\.gemrc' do
  source 'rails_server/gemrc'
  action :create
end

gem_package 'rails' do
  version '4.1.1'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

gem_package 'rake' do
  version '11.3.0'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

gem_package 'coffee-script-source' do
  version '1.10.0'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

gem_package 'execjs' do
  version '2.7.0'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

gem_package 'hike' do
  version '1.2.3'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

gem_package 'multi_json' do
  version '1.12.1'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

gem_package 'tilt' do
  version '1.4.1'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

gem_package 'sass' do
  version '3.2.19'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

gem_package 'sqlite3' do
  version '1.3.11'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

gem_package 'turbolinks-source' do
  version '5.0.0'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

gem_package 'rdoc' do
  version '4.2.2'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "-f --no-ri --no-rdoc"
end

gem_package 'coffee-script' do
  version '2.4.1'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

gem_package 'uglifier' do
  version '3.0.2'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

gem_package 'sprockets' do
  version '2.12.4'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

gem_package 'turbolinks' do
  version '5.0.1'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

gem_package 'sdoc' do
  version '0.4.2'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

gem_package 'tzinfo-data' do
  version '1.2016.7'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

gem_package 'jbuilder' do
  version '2.6.0'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

gem_package 'coffee-rails' do
  version '4.0.1'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

gem_package 'jquery-rails' do
  version '3.1.4'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

gem_package 'sass-rails' do
  version '4.0.5'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

gem_package 'debug_inspector' do
  version '0.0.2'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

gem_package 'binding_of_caller' do
  version '0.7.2'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

gem_package 'web-console' do
  version '2.1.2'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

gem_package 'minitest' do
  version '5.9.1'
  gem_binary 'C:\tools\ruby23\bin\gem'
  options "--no-ri --no-rdoc"
end

cookbook_file 'C:\tools\ruby23\lib\ruby\gems\2.3.0\specifications\sqlite3-1.3.11-x64-mingw32.gemspec' do
  source 'rails_server/sqlite3-1.3.11-x64-mingw32.gemspec'
  action :create
end

execute 'Create Rails server' do
  command 'C:\tools\ruby23\bin\rails.bat _4.1.1_ new "C:\Program Files\Rails_Server"'
  action :run
end

cookbook_file 'C:\Program Files\Rails_Server\start_rails_server.bat' do
  source 'rails_server/start_rails_server.bat'
  action :create
end

batch 'Install Rails service' do
  code <<-EOH
    schtasks /create /tn "rails" /tr "\"cmd.exe\" /c \'C:\\Program Files\\Rails_Server\\start_rails_server.bat\'" /sc onstart /NP /ru "SYSTEM"
    schtasks /Run /TN rails
  EOH
end

execute 'Add firewall rule' do
  command 'netsh advfirewall firewall add rule name="Open Port 3000 for Rails Server" dir=in action=allow protocol=TCP localport=3000'
  action :run
end