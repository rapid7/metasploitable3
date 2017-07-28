#
# Cookbook:: metasploitable
# Recipe:: boxstarter
#
# Copyright:: 2017, The Authors, All Rights Reserved.

batch 'Install Boxstarter' do
  code <<-EOH
    chocolatey feature enable -n=allowGlobalConfirmation
    choco install BoxStarter
    chocolatey feature disable -n=allowGlobalConfirmation
    EOH
end
