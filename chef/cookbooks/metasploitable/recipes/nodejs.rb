#
# Cookbook:: metasploitable
# Recipe:: nodejs
#
# Copyright:: 2017, Rapid7, All Rights Reserved.
#
#
execute 'add nodejs 4 repository' do
  command 'curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -'
  not_if { ::File.exist?('/usr/bin/node') }
end

package 'nodejs' do
  options '--force-yes'
end
