#
# Cookbook:: metasploitable
# Recipe:: vcredist
#
# Copyright:: 2017, The Authors, All Rights Reserved.

batch 'Install VCRedist' do
  code <<-EOH
    chocolatey feature enable -n=allowGlobalConfirmation
    choco install vcredist2008
    chocolatey feature disable -n=allowGlobalConfirmation
    EOH
end
