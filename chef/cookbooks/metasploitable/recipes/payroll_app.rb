#
# Cookbook:: metasploitable
# Recipe:: payroll_app
# Copyright:: 2017, Rapid7, All Rights Reserved.

cookbook_file '/var/www/html/payroll_app.php' do
  source 'payroll_app/payroll_app.php'
  mode '0755'
end

cookbook_file '/tmp/payroll.sql' do
  source 'payroll_app/payroll.sql'
  mode '0755'
end

directory '/home/vagrant/poc/payroll_app/' do
  mode '0755'
  owner 'vagrant'
  recursive true
end

cookbook_file '/home/vagrant/poc/payroll_app/poc.rb' do
  source 'payroll_app/poc.rb'
  mode '0755'
end

bash 'create payroll database and import data' do
  code <<-EOH
    mysql -S /var/run/mysql-default/mysqld.sock --user="root" --password="sploitme" --execute="CREATE DATABASE payroll;"
    mysql -S /var/run/mysql-default/mysqld.sock --user="root" --password="sploitme" payroll < /tmp/payroll.sql
  EOH
end
