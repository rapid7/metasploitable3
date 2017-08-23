#
# Cookbook:: metasploitable
# Recipe:: flags
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

# 10 of Clubs
directory '/home/artoo_detoo/music' do
  owner 'artoo_detoo'
  group 'users'
  mode '0700'
end

cookbook_file '/home/artoo_detoo/music/10_of_clubs.wav' do
  source 'flags/10_of_clubs.wav'
  owner 'artoo_detoo'
  group 'users'
  mode '0400'
end

# 7 of Diamonds
include_recipe 'metasploitable::docker'

directory '/opt/docker' do
  mode '0700'
end

cookbook_file '/opt/docker/Dockerfile' do
  source '/flags/Dockerfile'
  mode '0700'
end

cookbook_file '/opt/docker/7_of_diamonds.zip' do
  source '/flags/7_of_diamonds.zip'
  mode '0700'
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

if ENV['MS3_LINUX_HARD']
  # 5 of Diamonds
  include_recipe 'metasploitable::knockd'

  directory '/opt/knock_knock' do
    mode '0700'
  end

  cookbook_file '/opt/knock_knock/five_of_diamonds' do
    source 'flags/five_of_diamonds'
    mode '0700'
  end

  cookbook_file '/etc/init/five_of_diamonds_srv.conf' do
    source 'flags/five_of_diamonds_srv'
    mode '0777'
  end

  service 'five_of_diamonds_srv' do
    action [:enable, :start]
  end

  # 2 of Spades
  cookbook_file '/home/leia_organa/2_of_spades.pcapng' do
    source 'flags/2_of_spades.pcapng'
    owner 'leia_organa'
    mode '0600'
  end

  # 8 of Hearts
  include_recipe 'metasploitable::mysql'

  bash "load 8 of hearts into DB" do
    code <<-EOH
    mysql -h 127.0.0.1 --user="root" --password="sploitme" --execute="CREATE DATABASE super_secret_db;"
    mysql -h 127.0.0.1 --user="root" --password="sploitme" --execute="GRANT SELECT, INSERT, DELETE, CREATE, DROP, INDEX, ALTER ON drupal.* TO 'root'@'localhost' IDENTIFIED BY 'sploitme';"
    mysql -h 127.0.0.1 --user="root" --password="sploitme" super_secret_db < #{File.join(Chef::Config[:file_cache_path], 'cookbooks', 'metasploitable', 'files', 'flags', 'super_secret_db.sql')}
    EOH
    not_if "mysql -h 127.0.0.1 --user=\"root\" --password=\"sploitme\" --execute=\"SHOW DATABASES LIKE 'super_secret_db'\" | grep -c drupal"
  end

  # Joker - red
  cookbook_file '/etc/joker.png' do
    source 'flags/joker.png'
    mode '0600'
  end
else
  # 10 of Spades
  include_recipe 'metasploitable::readme_app'

  cookbook_file '/opt/readme_app/public/images/10_of_spades.png' do
    source 'flags/flag_images/10 of spades.png'
    mode '0644'
  end

  # 8 of Clubs
  random_directories = Array.new(20) { rand(1..100) }
  prev_dirs = []

  random_directories.each do |dir|
    directory File.join('home', 'anakin_skywalker', prev_dirs.join('/'), dir.to_s) do
      mode '0600'
      owner 'anakin_skywalker'
      group 'users'
    end
    prev_dirs << dir
  end

  cookbook_file File.join('home', 'anakin_skywalker', random_directories.join('/'), '8_of_clubs.png') do
    source 'flags/flag_images/8 of clubs.png'
    mode '0644'
    owner 'anakin_skywalker'
    group 'users'
  end

  # 3 of Hearts
  cookbook_file '/lost+found/3_of_hearts.png' do
    source 'flags/flag_images/3 of hearts.png'
    mode '0600'
  end

  # 9 of Diamonds
  directory '/home/kylo_ren/.secret_files/' do
    mode '0600'
    owner 'kylo_ren'
    group 'users'
  end

  cookbook_file '/home/kylo_ren/.secret_files/my_recordings_do_not_open.iso' do
    source 'flags/my_recordings_do_not_open.iso'
    mode '0600'
    owner 'kylo_ren'
    group 'users'
  end
end


