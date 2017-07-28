#
# Cookbook:: metasploitable
# Recipe:: 7zip
#
# Copyright:: 2017, The Authors, All Rights Reserved.

batch 'Install 7zip' do
  code <<-EOH
    chocolatey feature enable -n=allowGlobalConfirmation
    choco install 7zip
    chocolatey feature disable -n=allowGlobalConfirmation
    EOH
end
