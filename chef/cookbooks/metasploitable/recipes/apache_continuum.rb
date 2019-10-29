#
# Cookbook:: metasploitable
# Recipe:: apache_continuum
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

package 'openjdk-6-jre'
package 'openjdk-6-jdk'

directory node[:apache_continuum][:install_dir] do
  owner 'root'
  group 'root'
  mode '0644'
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node[:apache_continuum][:tar]}" do
  source "#{node[:apache_continuum][:download_url]}/#{node[:apache_continuum][:tar]}"
  mode '0644'
end

execute "extract apache continum" do
  cwd Chef::Config[:file_cache_path]
  command "tar -xvzf #{node[:apache_continuum][:tar]} -C #{node[:apache_continuum][:install_dir]}"

  not_if { ::File.exists?(File.join(node[:apache_continuum][:install_dir], 'apache-continuum-1.4.2'))}
end

bash 'Download and extract Apache Continuum 1.4.2' do
  cwd File.join(node[:apache_continuum][:install_dir],'apache-continuum-1.4.2')
  code <<-EOH
    rm bin/wrapper-linux-x86-32
    rm -rf data
    tar --warning=no-unknown-keyword -xvzf #{File.join(Chef::Config[:file_cache_path], 'cookbooks', 'metasploitable', 'files', 'apache_continuum', 'data.tar.gz')} -C #{File.join(node[:apache_continuum][:install_dir], 'apache-continuum-1.4.2')}
  EOH
end

link '/etc/init.d/continuum' do
  to File.join(node[:apache_continuum][:install_dir], 'apache-continuum-1.4.2', 'bin', 'continuum')
end

execute "set port for apache continuum" do
  command 'update-rc.d continuum defaults 80'
end

service 'continuum' do
  action [:enable, :start]
end