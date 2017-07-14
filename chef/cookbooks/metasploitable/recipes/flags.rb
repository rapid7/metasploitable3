#
# Cookbook:: metasploitable
# Recipe:: flags
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

directory '/opt/knock_knock' do
  mode 0700
end

cookbook_file '/opt/knock_knock/five_of_diamonds' do
  source 'flags/five_of_diamonds'
  mode 0700
end

cookbook_file '/etc/init.d/five_of_diamonds_srv' do
  source 'flags/five_of_diamonds_srv'
  mode '760'
end

service 'five_of_diamonds_srv' do
  action [:enable, :start]
end

directory '/home/artoo_detoo/music' do
  mode 700
end

cookbook_file '/home/artoo_detoo//music/10_of_clubs.wav' do
  source 'flags/10_of_clubs.wav'
  mode 400
end

cookbook_file '/etc/joker.png' do
  source 'flagsjoker.png'
  mode 644
end

bash "load 8 of hearts into DB" do
  code <<-EOH
    mysql -h 127.0.0.1 --user="root" --password="sploitme" --execute="CREATE DATABASE super_secret_db;"
    mysql -h 127.0.0.1 --user="root" --password="sploitme" --execute="GRANT SELECT, INSERT, DELETE, CREATE, DROP, INDEX, ALTER ON drupal.* TO 'root'@'localhost' IDENTIFIED BY 'sploitme';"
    mysql -h 127.0.0.1 --user="root" --password="sploitme" super_secret_db < #{File.join(node[:metasploitable][:files_path], 'flags', 'super_secret_db.sql')}
  EOH
  not_if "mysql -h 127.0.0.1 --user=\"root\" --password=\"sploitme\" --execute=\"SHOW DATABASES LIKE 'super_secret_db'\" | grep -c drupal"
end
