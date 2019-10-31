#
# Cookbook:: metasploitable
# Recipe:: chatbot
#
# Copyright:: 2017, Rapid7, All Rights Reserved.
#
#

include_recipe 'metasploitable::ruby23'
include_recipe 'metasploitable::nodejs'
include_recipe 'iptables::default'

iptables_rule '1_chatbot_ui' do
  lines "-A INPUT -p tcp --dport 80 -j ACCEPT"
end

iptables_rule '1_chatbot_nodejs' do
  lines "-A INPUT -p tcp --dport 3000 -j ACCEPT"
end

package 'unzip'

bash "Install dependencies" do
  code <<-EOH
    npm install express
    npm install cors
  EOH
end

cookbook_file '/tmp/chatbot.zip' do
  source 'chatbot/chatbot.zip'
  mode '0700'
end

execute 'unzip chatbot' do
  command 'unzip /tmp/chatbot.zip -d /opt'
  only_if { Dir['/opt/chatbot'].empty? }
  notifies :run, 'execute[chown chatbot]', :immediately
  notifies :run, 'execute[chmod chatbot]', :immediately
  notifies :run, 'execute[install chatbot]', :immediately
end

execute 'chown chatbot' do
  command "chown -R root:root /opt/chatbot"
end

execute 'chmod chatbot' do
  command 'chmod -R 700 /opt/chatbot'
end

execute 'install chatbot' do
  command '/opt/chatbot/install.sh'
  not_if { File.exists?( '/etc/init/chatbot.conf' ) }
end

service 'chatbot' do
  supports restart: false, start: true, reload: false, status: false
  action [:enable, :start]
end
