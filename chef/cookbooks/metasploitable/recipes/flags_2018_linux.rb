#
# Cookbook:: metasploitable
# Recipe:: flags
#
# Copyright:: 2018, Rapid7, All Rights Reserved.

docker_service 'default' do
  action [:create, :start]
  group 'docker'
end

remote_directory "/opt/flags" do
  source 'flags_2018'
  files_owner 'root'
  files_group 'root'
  files_mode '0755'
  action :create
  recursive true
end

bash 'build sound server' do
  code <<-EOH
    apt-get update
    apt-get install -y linux-image-generic alsa-utils build-essential libasound-dev libbz2-dev
    modprobe snd-aloop docker
    make -C /opt/flags/king_of_diamonds/src
    cp /opt/flags/king_of_diamonds/src/corey /usr/sbin/corey
    systemctl enable rc-local.service
    echo "#!/bin/sh -e" > /etc/rc.local
    echo "modprobe snd-aloop docker" >> /etc/rc.local
    echo "/usr/sbin/corey &" >> /etc/rc.local
  EOH
end

execute 'build and deploy flags' do
  cwd '/opt/flags'
  command './build.sh --persist'
  live_stream true
end

bash 'vm tweaks' do
  code <<-EOH
    systemctl disable apt-daily.service
    systemctl disable apt-daily.timer
    systemctl disable apt-daily-upgrade.timer
    systemctl disable apt-daily-upgrade.service
    #systemctl disable sshd.service
    echo "docker restart $(docker ps -a -q)" >> /etc/rc.local
  EOH
end
