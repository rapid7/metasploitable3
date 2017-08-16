#
# Cookbook:: metasploitable
# Recipe:: flags
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

include_recipe 'metasploitable::knockd'
include_recipe 'metasploitable::docker'

directory '/opt/knock_knock' do
  mode 0700
end

cookbook_file '/opt/knock_knock/five_of_diamonds' do
  source 'flags/five_of_diamonds'
  mode 0700
end

cookbook_file '/etc/init/five_of_diamonds_srv.conf' do
  source 'flags/five_of_diamonds_srv'
  mode 777
end

service 'five_of_diamonds_srv' do
  action [:enable, :start]
end

directory '/home/artoo_detoo/music' do
  owner 'artoo_detoo'
  mode 700
end

cookbook_file '/home/artoo_detoo/music/10_of_clubs.wav' do
  source 'flags/10_of_clubs.wav'
  owner 'artoo_detoo'
  mode 400
end

cookbook_file '/etc/joker.png' do
  source 'flags/joker.png'
  mode 600
end

bash "load 8 of hearts into DB" do
  code <<-EOH
    mysql -h 127.0.0.1 --user="root" --password="sploitme" --execute="CREATE DATABASE super_secret_db;"
    mysql -h 127.0.0.1 --user="root" --password="sploitme" --execute="GRANT SELECT, INSERT, DELETE, CREATE, DROP, INDEX, ALTER ON drupal.* TO 'root'@'localhost' IDENTIFIED BY 'sploitme';"
    mysql -h 127.0.0.1 --user="root" --password="sploitme" super_secret_db < #{File.join(Chef::Config[:file_cache_path], 'cookbooks', 'metasploitable', 'files', 'flags', 'super_secret_db.sql')}
  EOH
  not_if "mysql -h 127.0.0.1 --user=\"root\" --password=\"sploitme\" --execute=\"SHOW DATABASES LIKE 'super_secret_db'\" | grep -c drupal"
end

directory '/opt/docker' do
  mode 700
end

cookbook_file '/opt/docker/Dockerfile' do
  source '/flags/Dockerfile'
  mode 700
end

cookbook_file '/opt/docker/7_of_diamonds.zip' do
  source '/flags/7_of_diamonds.zip'
  mode 700
end

bash 'build docker image for 7 of diamonds' do
  code <<-EOH
    cd /opt/docker
    docker build -t "7_of_diamonds" .
    docker run -dit --restart always --name 7_of_diamonds 7_of_diamonds
  EOH
end

file '/opt/docker/7_of_diamonds.zip' do
  action :delete
end

cookbook_file '/home/leia_organa/2_of_spades.pcapng' do
  source '/flags/2_of_spades.pcapng'
  owner 'leia_organa'
  mode 600
end
