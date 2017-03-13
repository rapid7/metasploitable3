#
# Cookbook:: metasploitable
# Recipe:: apache
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

execute 'apt-get update' do
  command 'apt-get update'
end

package 'apache2' do
  action :install
end

directory '/var/www/cgi-bin' do
  mode '0755'
  recursive true
end

cookbook_file '/var/www/cgi-bin/hello_world.sh' do
  source 'apache/hello_world.sh'
  mode '0755'
end

cookbook_file '/etc/apache2/conf-available/cgi-bin.conf' do
  source 'apache/cgi-bin.conf'
  mode '0644'
end

execute 'enable-cgi-mod' do
  command 'a2enmod cgi'
end

execute 'enable-cgi-bin-conf' do
  command 'a2enconf cgi-bin'
end

execute 'disable-serve-cgi-bin-conf' do
  command 'a2disconf serve-cgi-bin'
end

service 'apache2' do
  action [:enable, :start]
end


