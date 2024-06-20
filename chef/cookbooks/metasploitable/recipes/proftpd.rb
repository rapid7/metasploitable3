#
# Cookbook:: metasploitable
# Recipe:: proftpd
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

# Install steps taken from https://github.com/rapid7/metasploit-framework/pull/5224

include_recipe 'iptables::default'

iptables_rule '1_proftpd' do
  lines "-A INPUT -p tcp --dport 21 -j ACCEPT"
end

include_recipe 'metasploitable::apache'

proftpd_tar = 'proftpd-1.3.5.tar.gz'

execute "extract proftpd" do
  cwd Chef::Config[:file_cache_path]
  command 'tar zxfv proftpd-1.3.5.tar.gz'
  not_if { ::File.exists?(File.join(Chef::Config[:file_cache_path], 'proftpd-1.3.5'))}
  action :nothing
end

bash 'compile and install proftpd' do
  cwd "#{Chef::Config[:file_cache_path]}/proftpd-1.3.5"
  code <<-EOH
    ./configure --prefix=/opt/proftpd --with-modules=mod_copy \
    && make && make install
  EOH
  not_if { ::File.exist?( '/opt/proftpd/sbin/proftpd') }
  action :nothing
end

remote_file "#{Chef::Config[:file_cache_path]}/#{proftpd_tar}" do
  source "#{node[:proftpd][:download_url]}/#{proftpd_tar}"
  mode '0644'
  action :create_if_missing
  not_if { File.exists?( '/opt/proftpd/sbin/proftpd' ) }
  notifies :run, 'execute[extract proftpd]', :immediately
  notifies :run, 'bash[compile and install proftpd]', :immediately
end

execute 'add hostname to /etc/hosts' do
  command "echo #{node[:ipaddress]} #{node[:hostname]} >> /etc/hosts"
  not_if 'grep -q "#{node[:ipaddress]} #{node[:hostname]}" /etc/hosts'
end

cookbook_file '/etc/init.d/proftpd' do
  source 'proftpd/proftpd'
  mode '755'
end

execute 'remove_carriage_returns' do
  command "sed -i -e 's/\r//g' /etc/init.d/proftpd"
end


# Setup the IP Renewer
cookbook_file '/opt/proftpd/proftpd_ip_renewer.rb' do
  source 'proftpd/proftpd_ip_renewer.rb'
  mode '744'
  owner 'root'
  group 'root'
end


cookbook_file '/etc/init/proftpd_ip_renewer.conf' do
  source 'proftpd/proftpd_ip_renewer.conf'
  mode '0644'
end

cookbook_file '/opt/proftpd/hosts_renewer.rb' do
  source 'proftpd/hosts_renewer.rb'
  mode '744'
  owner 'root'
  group 'root'
end

cookbook_file '/etc/init/hosts_renewer.conf' do
  source 'proftpd/hosts_renewer.conf'
  mode '0644'
end

service 'proftpd' do
  action [:enable, :start]
  supports :status => true
end

service 'proftpd_ip_renewer' do
  action [:enable, :start]
end

service 'hosts_renewer' do
  action [:enable, :start]
end
