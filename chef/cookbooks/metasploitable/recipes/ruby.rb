#
# Cookbook:: metasploitable
# Recipe:: ruby
#
# Copyright:: 2017, The Authors, All Rights Reserved.

batch 'Install Ruby' do
  code <<-EOH
    choco install -y ruby --version 2.3.3
    refreshenv
  EOH
end
