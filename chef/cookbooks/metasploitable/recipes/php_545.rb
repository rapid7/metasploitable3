#
# Cookbook:: metasploitable
# Recipe:: php_545
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

# General steps pulled from here: http://askubuntu.com/questions/597462/how-to-install-php-5-2-x-on-ubuntu-14-04

execute "apt-get update" do
  command "apt-get update"
end

execute "install prereqs" do
  command "apt-get install -y gcc make build-essential \
    libxml2-dev libcurl4-openssl-dev libpcre3-dev libbz2-dev libjpeg-dev \
    libpng12-dev libfreetype6-dev libt1-dev libmcrypt-dev libmhash-dev \
    freetds-dev libmysqlclient-dev unixodbc-dev \
    libxslt1-dev php5-mysql apache2-dev"
end

execute "fix freetype bug" do
  command "mkdir -pv /usr/include/freetype2/freetype && ln -sf /usr/include/freetype2/freetype.h /usr/include/freetype2/freetype/freetype.h"
end

bash "download, extract, and patch php source" do
  code <<-EOH
    wget -c -t 3 -O /home/vagrant/php-5.4.5.tar.gz http://museum.php.net/php5/php-5.4.5.tar.gz
    tar xvfz /home/vagrant/php-5.4.5.tar.gz -C /home/vagrant/
    cd /home/vagrant/php-5.4.5
    wget -c -t 3 -O ./libxml29_compat.patch https://mail.gnome.org/archives/xml/2012-August/txtbgxGXAvz4N.txt
    patch -p0 -b < libxml29_compat.patch
  EOH
end

bash "compile and install php" do
  code <<-EOH
    cd /home/vagrant/php-5.4.5
    ./configure --with-apxs2=/usr/bin/apxs --with-mysqli --enable-embedded-mysqli
    make
    make install
  EOH
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

# ln -s ../mods-available/php5.conf
# ln -s ../mods-available/php5.load

service 'apache2' do
  action [:restart]
end
