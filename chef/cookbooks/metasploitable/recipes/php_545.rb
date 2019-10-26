#
# Cookbook:: metasploitable
# Recipe:: php_545
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

# General steps pulled from here: http://askubuntu.com/questions/597462/how-to-install-php-5-2-x-on-ubuntu-14-04

include_recipe 'metasploitable::apache'

php_tar = "php-5.4.5.tar.gz"

execute "install prereqs" do
  command "apt-get install -y gcc make build-essential \
    libxml2-dev libcurl4-openssl-dev libpcre3-dev libbz2-dev libjpeg-dev \
    libpng12-dev libfreetype6-dev libt1-dev libmcrypt-dev libmhash-dev \
    freetds-dev libmysqlclient-dev unixodbc-dev \
    libxslt1-dev apache2-dev"
end

execute "fix freetype bug" do
  command "mkdir -pv /usr/include/freetype2/freetype && ln -sf /usr/include/freetype2/freetype.h /usr/include/freetype2/freetype/freetype.h"
end

remote_file "#{Chef::Config[:file_cache_path]}/#{php_tar}" do
  source "#{node[:php545][:download_url]}/#{php_tar}"
  mode '0644'
  action :create_if_missing
  not_if 'apache2ctl -M | grep -q php5'
end

remote_file "#{Chef::Config[:file_cache_path]}/libxml29_compat.patch" do
  source "https://mail.gnome.org/archives/xml/2012-August/txtbgxGXAvz4N.txt"
  mode '0644'
  action :create_if_missing
  not_if 'apache2ctl -M | grep -q php5'
end

execute "patch php" do
  cwd "#{Chef::Config[:file_cache_path]}/php-5.4.5"
  command "patch -p0 -b < ../libxml29_compat.patch"
  action :nothing
end

execute "extract php" do
  cwd Chef::Config[:file_cache_path]
  command "tar xvzf #{Chef::Config[:file_cache_path]}/#{php_tar} -C #{Chef::Config[:file_cache_path]}"
  only_if {Dir["#{Chef::Config[:file_cache_path]}/php-5.4.5"].empty?}
  not_if 'apache2ctl -M | grep -q php5'
  notifies :run, 'execute[patch php]', :immediately
end


bash "compile and install php" do
  cwd "#{Chef::Config[:file_cache_path]}/php-5.4.5"
  code <<-EOH
    ./configure --with-apxs2=/usr/bin/apxs --with-mysqli --enable-embedded-mysqli --with-gd --with-mcrypt --enable-mbstring --with-pdo-mysql \
    && make && make install
  EOH
  not_if 'apache2ctl -M | grep -q php5'
end

cookbook_file 'etc/apache2/mods-available/php5.conf' do
  source 'apache/php5.conf'
end

cookbook_file 'etc/apache2/mods-available/php5.load' do
  source 'apache/php5.load'
end

bash "enable php modules" do
  code <<-EOH
    cd /etc/apache2/mods-enabled
    a2enmod php5
    a2dismod mpm_event
    a2enmod mpm_prefork
  EOH
end

service 'apache2' do
  action [:restart]
end
