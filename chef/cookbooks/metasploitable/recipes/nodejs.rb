#
# Cookbook:: metasploitable
# Recipe:: nodejs
#
# Copyright:: 2017, Rapid7, All Rights Reserved.
#
#

execute 'add nodejs 4 repository' do
  command 'curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -'
end

execute "apt-get update" do
  command "apt-get update"
end

package 'nodejs'
