#
# Cookbook:: metasploitable
# Recipe:: java
#
# Copyright:: 2017, The Authors, All Rights Reserved.

batch 'Install Java' do
  code <<-EOH
    chocolatey feature enable -n=allowGlobalConfirmation
    choco install javaruntime-platformspecific
    chocolatey feature disable -n=allowGlobalConfirmation
    EOH
end
