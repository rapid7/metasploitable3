#
# Cookbook:: sinatra
# Recipe:: sinatra
#
# Copyright:: 2017, Rapid7, All Rights Reserved.
#
#

include_recipe 'metasploitable::sinatra'

package 'unzip'

package 'npm'

package 'bundler'

cookbook_file '/tmp/chatbot.zip' do
  source 'chatbot/chatbot.zip'
  mode '0777'
end

execute 'unzip chatbot' do
  command 'unzip /tmp/chatbot.zip -d /opt'
end

execute 'chown chatbot' do
  command 'chown -R vagrant:vagrant /opt/chatbot'
end

execute 'chmod chatbot' do
  command 'chmod -R 777 /opt/chatbot'
end

execute 'install chatbot' do
  command '/opt/chatbot/install.sh'
end

service 'chatbot' do
  supports restart: false, start: true, reload: false, status: false
  action [:enable, :start]
end
