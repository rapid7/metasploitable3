#
# Cookbook:: metasploitable
# Recipe:: drupal
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

include_recipe 'metasploitable::apache'
include_recipe 'metasploitable::mysql'
include_recipe 'metasploitable::php_545'

drupal_tar    = "drupal-#{node[:drupal][:version]}.tar.gz"
coder_tar     = "coder-7.x-2.5.tar.gz"
files_path    = File.join(Chef::Config[:file_cache_path], 'cookbooks', 'metasploitable', 'files', 'drupal')

remote_file "#{Chef::Config[:file_cache_path]}/#{drupal_tar}" do
  source "#{node[:drupal][:download_url]}/#{drupal_tar}"
  mode 00644
end

remote_file "#{Chef::Config[:file_cache_path]}/#{coder_tar}" do
  source "#{node[:drupal][:download_url]}/#{coder_tar}"
  mode 00644
end

directory node[:drupal][:install_dir] do
  owner 'www-data'
  group 'www-data'
  recursive true
  mode '0755'
end

log "debug logging" do
  message "#{Dir["#{node[:drupal][:install_dir]}/*"]}"
  level :info
end

execute 'untar drupal' do
  cwd node[:drupal][:install_dir]
  command "tar xvzf #{Chef::Config[:file_cache_path]}/#{drupal_tar} --strip-components 1"

  only_if { Dir["#{node[:drupal][:install_dir]}/*"].empty? }
end

execute 'untar default site' do
  cwd node[:drupal][:sites_dir]
  command "tar xvzf #{File.join(files_path, 'default_site.tar.gz')}"
  not_if { ::File.exists?(File.join(node[:drupal][:default_site_dir], 'settings.php')) }
  not_if { ::File.directory?(File.join(node[:drupal][:default_site_dir], 'files')) }
end

execute 'untar coder module' do
  cwd File.join(node[:drupal][:all_site_dir], 'modules')
  command "tar xvzf #{Chef::Config[:file_cache_path]}/#{coder_tar}"
  not_if { ::File.directory?(File.join(node[:drupal][:all_site_dir], 'modules', 'coder')) }
end

execute "set permissions" do
  command "chown -R www-data:www-data #{node[:drupal][:install_dir]}"
end

bash "create drupal database and inject data" do
  code <<-EOH
    mysql -h 127.0.0.1 --user="root" --password="sploitme" --execute="CREATE DATABASE drupal;"
    mysql -h 127.0.0.1 --user="root" --password="sploitme" --execute="GRANT SELECT, INSERT, DELETE, CREATE, DROP, INDEX, ALTER ON drupal.* TO 'root'@'localhost' IDENTIFIED BY 'sploitme';"
    mysql -h 127.0.0.1 --user="root" --password="sploitme" drupal < #{File.join(files_path, 'drupal.sql')}
  EOH
  not_if "mysql -h 127.0.0.1 --user=\"root\" --password=\"sploitme\" --execute=\"SHOW DATABASES LIKE 'drupal'\" | grep -c drupal"
end

# This step is necessary because Drupal rewrites our 5_of_hearts.png,
# which causes the metadata to be lost.
cookbook_file '/var/www/html/drupal/sites/default/files/styles/large/public/field/image/5_of_hearts.png' do
  source 'flags/5_of_hearts.png'
  mode '777'
end

cookbook_file '/var/www/html/drupal/sites/default/files/field/image/5_of_hearts.png' do
  source 'flags/5_of_hearts.png'
  mode '777'
end
