#
# Cookbook:: metasploitable
# Recipe:: ingreslock
#
# Copyright:: 2020, Rapid7, All Rights Reserved.

include_recipe 'iptables::default'

iptables_rule '01_ingreslock' do
  lines "-A INPUT -p tcp --dport 1524 -j ACCEPT"
end

package 'inetutils-inetd' do
  action :install
end

# needs to happen before starting the service --
# otherwise, if no services listed in inetd.conf,
# inetd will refuse to start.
execute 'add ingreslock to /etc/inetd.conf' do
  command "echo 'ingreslock stream tcp nowait root /bin/bash bash -i' >> /etc/inetd.conf"
  not_if "grep -q 'ingreslock stream tcp nowait root /bin/bash bash -i' /etc/inetd.conf"
end

service 'inetutils-inetd' do
  action [:enable, :start]
end
