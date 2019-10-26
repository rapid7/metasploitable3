#
# Cookbook:: metasploitable
# Recipe:: apache
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

package 'apache2' do
  action :install
end

directory '/var/www/cgi-bin' do
  mode '0755'
  recursive true
end

directory '/var/www/uploads' do
  mode '0777'
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

cookbook_file '/etc/apache2/conf-available/dav.conf' do
  source 'apache/dav.conf'
  mode '0644'
end

bash "configure cgi" do
  code <<-EOH
    a2enmod cgi
    a2enconf cgi-bin
    a2disconf serve-cgi-bin
  EOH
end

bash "configure webDAV" do
  code <<-EOH
    a2enmod dav
    a2enmod dav_fs
    a2enmod dav_lock
    a2enmod auth_digest
    a2enconf dav
  EOH
end

execute 'make /var/www/html writeable' do
  command 'chmod o+w /var/www/html'
end

file '/var/www/html/index.html' do
  action :delete
  only_if { File.exists?('/var/www/html/index.html') }
end

service 'apache2' do
  action [:enable, :start]
end
