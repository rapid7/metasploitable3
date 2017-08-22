#
# Cookbook:: metasploitable
# Recipe:: unrealircd.rb
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

# Downloaded from https://www.exploit-db.com/exploits/13853/
# Install steps taken from https://wiki.swiftirc.net/wiki/Installing_and_Configuring_UnrealIRCd_on_Linux

unreal_tar = 'Unreal3.2.8.1_backdoor.tar.gz'

remote_file "#{Chef::Config[:file_cache_path]}/#{unreal_tar}" do
  source "#{node[:unrealircd][:download_url]}/752e46f2d873c1679fa99de3f52a274d-Unreal3.2.8.1_backdoor.tar_.gz"
  mode '0644'
end

directory node[:unrealircd][:install_dir] do
  owner 'boba_fett'
  recursive true
  mode '0100'
end

execute 'untar unrealircd' do
  cwd node[:unrealircd][:install_dir]
  command "tar xvzf #{Chef::Config[:file_cache_path]}/#{unreal_tar}"

  only_if { Dir["#{node[:unrealircd][:install_dir]}/*"].empty? }
end

# bash 'download and extract UnrealIRCd' do
#   code <<-EOH
#     wget -c -t 3 -O /tmp/Unreal3.2.8.1_backdoor.tar.gz https://www.exploit-db.com/apps/752e46f2d873c1679fa99de3f52a274d-Unreal3.2.8.1_backdoor.tar_.gz
#     mkdir /opt/unrealircd
#     tar xvfz /tmp/Unreal3.2.8.1_backdoor.tar.gz -C /opt/unrealircd
#     chmod 700 /opt/unrealircd/Unreal3.2
#   EOH
# end

cookbook_file '/opt/unrealircd/Unreal3.2/unrealircd.conf' do
  source 'unrealircd/unrealircd.conf'
  owner 'boba_fett'
  mode '0400'
end

cookbook_file '/opt/unrealircd/Unreal3.2/ircd.motd' do
  source 'unrealircd/ircd.motd'
  owner 'boba_fett'
  mode '0400'
end

bash 'configure and compile' do
  code <<-EOH
    cd /opt/unrealircd/Unreal3.2
    ./configure --with-showlistmodes --enable-hub --enable-prefixaq --with-listen=5 --with-dpath=/opt/unrealircd/Unreal3.2 --with-spath=/opt/unrealircd/Unreal3.2/src/ircd --with-nick-history=2000 --with-sendq=3000000 --with-bufferpool=18 --with-hostname=metasploitableub --with-permissions=0600 --with-fd-setsize=1024 --enable-dynamic-linking
    make
  EOH
end

execute 'set owner and permissions' do
  command "chown -R boba_fett #{node[:unrealircd][:install_dir]}"
  user 'root'
  action :run
end

cookbook_file '/etc/init.d/unrealircd' do
  source 'unrealircd/unrealircd'
  mode '760'
end

execute 'start unrealircd service' do
  # This should ideally be a service resource but for some reason chef doesn't start the service properly when it is.
  command '/etc/init.d/unrealircd start'
end
