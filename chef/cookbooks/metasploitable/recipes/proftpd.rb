#
# Cookbook:: metasploitable
# Recipe:: proftpd
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

# Install steps taken from https://github.com/rapid7/metasploit-framework/pull/5224

include_recipe 'metasploitable::apache'

proftpd_tar = 'proftpd-1.3.5.tar.gz'

remote_file "#{Chef::Config[:file_cache_path]}/#{proftpd_tar}" do
  source "#{node[:proftpd][:download_url]}/#{proftpd_tar}"
  mode '0644'
end

execute "extract proftpd" do
  cwd Chef::Config[:file_cache_path]
  command 'tar zxfv proftpd-1.3.5.tar.gz'

  not_if { ::File.exists?(File.join(Chef::Config[:file_cache_path], 'proftpd-1.3.5'))}
end

bash 'compile and install proftpd' do
  cwd "#{Chef::Config[:file_cache_path]}/proftpd-1.3.5"
  code <<-EOH
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
