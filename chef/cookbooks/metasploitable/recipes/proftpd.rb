#
# Cookbook:: proftpd
# Recipe:: phpmyadmin
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

# Install steps taken from https://github.com/rapid7/metasploit-framework/pull/5224

include_recipe 'metasploitable::apache'

bash "download, extract, and compile proftpd" do
  code <<-EOH
    cd /home/vagrant
    wget "ftp://ftp.proftpd.org/distrib/source/proftpd-1.3.5.tar.gz"
    tar zxfv proftpd-1.3.5.tar.gz
    cd proftpd-1.3.5
    ./configure --prefix=/opt/proftpd --with-modules=mod_copy
    make
    make install
  EOH
end

cookbook_file '/etc/init.d/proftpd' do
  source 'proftpd/proftpd'
  mode '760'
end

service 'proftpd' do
  action [:enable, :start]
end
