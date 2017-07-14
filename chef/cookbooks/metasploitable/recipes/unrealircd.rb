#
# Cookbook:: metasploitable
# Recipe:: unrealircd.rb
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

# Downloaded from https://www.exploit-db.com/exploits/13853/
# Install steps taken from https://wiki.swiftirc.net/wiki/Installing_and_Configuring_UnrealIRCd_on_Linux

bash 'download and extract UnrealIRCd' do
  code <<-EOH
    wget -c -t 3 -O /tmp/Unreal3.2.8.1_backdoor.tar.gz https://www.exploit-db.com/apps/752e46f2d873c1679fa99de3f52a274d-Unreal3.2.8.1_backdoor.tar_.gz
    mkdir /opt/unrealircd
    tar xvfz /tmp/Unreal3.2.8.1_backdoor.tar.gz -C /opt/unrealircd
    chmod 755 /opt/unrealircd/Unreal3.2
  EOH
end

cookbook_file '/opt/unrealircd/Unreal3.2/unrealircd.conf' do
  source 'unrealircd/unrealircd.conf'
end

cookbook_file '/opt/unrealircd/Unreal3.2/ircd.motd' do
  source 'unrealircd/ircd.motd'
end

bash 'configure and compile' do
  code <<-EOH
    cd /opt/unrealircd/Unreal3.2
    ./configure --with-showlistmodes --enable-hub --enable-prefixaq --with-listen=5 --with-dpath=/opt/unrealircd/Unreal3.2 --with-spath=/opt/unrealircd/Unreal3.2/src/ircd --with-nick-history=2000 --with-sendq=3000000 --with-bufferpool=18 --with-hostname=metasploitableub --with-permissions=0600 --with-fd-setsize=1024 --enable-dynamic-linking
    make
  EOH
end

cookbook_file '/etc/init.d/unrealircd' do
  source 'unrealircd/unrealircd'
  mode '760'
end

service 'unrealircd' do
  action [:enable, :start]
end
