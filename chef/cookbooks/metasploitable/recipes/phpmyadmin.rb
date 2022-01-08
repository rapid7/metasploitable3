#
# Cookbook:: metasploitable
# Recipe:: phpmyadmin
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

include_recipe 'metasploitable::mysql'
include_recipe 'metasploitable::apache'
include_recipe 'metasploitable::php_545'

bash "download and extract phpmyadmin" do
  code <<-EOH
    wget -c -t 3 --no-check-certificate -O /tmp/phpMyAdmin-3.5.8-all-languages.tar.gz https://files.phpmyadmin.net/phpMyAdmin/3.5.8/phpMyAdmin-3.5.8-all-languages.tar.gz
    echo "a129d4f03901c047799f634b122734ab687b48975563c87adbf5dea679676e11  /tmp/phpMyAdmin-3.5.8-all-languages.tar.gz" | shasum -a 256 --check --status
    tar xvfz /tmp/phpMyAdmin-3.5.8-all-languages.tar.gz -C /var/www/html
    mv /var/www/html/phpMyAdmin-3.5.8-all-languages /var/www/html/phpmyadmin
  EOH
  not_if { ::File.exists?('/var/www/html/phpmyadmin') }
end

cookbook_file 'var/www/html/phpmyadmin/config.inc.php' do
  source 'phpmyadmin/config.inc.php'
end

service 'apache2' do
  action [:restart]
end
