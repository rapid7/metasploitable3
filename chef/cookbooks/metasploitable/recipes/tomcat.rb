#
# Cookbook:: metasploitable
# Recipe:: tomcat
#
# Copyright:: 2017, The Authors, All Rights Reserved.

batch 'Install Tomcat' do
  code <<-EOH
    chocolatey feature enable -n=allowGlobalConfirmation
    choco install tomcat --version 8.0.33
    chocolatey feature disable -n=allowGlobalConfirmation
    EOH
end
