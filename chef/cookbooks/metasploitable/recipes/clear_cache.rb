#
# Cookbook:: metasploitable
# Recipe:: clear_cache
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

bash 'clear cache and backup that might contain sensitive information' do
  code <<-EOH
  cd /var/chef
  rm -R *
  EOH
end
