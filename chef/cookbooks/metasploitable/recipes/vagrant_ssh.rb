#
# Cookbook:: metasploitable
# Recipe:: vagrant_ssh
#
# Copyright:: 2017, The Authors, All Rights Reserved.

directory 'C:\\Users\\vagrant\\.ssh' do
  action :create
end

directory 'C:\\Users\\vagrant\\.ssh\\authorized_keys' do
  action :create
end

powershell_script 'download_public_key' do
  code "(New-Object System.Net.WebClient).DownloadFile(\'http://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub\', \'C:\\Users\\vagrant\\.ssh\\authorized_keys\\vagrant.pub\')"
end
