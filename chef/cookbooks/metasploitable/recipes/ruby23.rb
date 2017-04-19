#
# Cookbook:: metasploitable
# Recipe:: ruby23
#
# Copyright:: 2017, Rapid7, All Rights Reserved.
#
#

execute 'apt-get update' do
  command 'apt-get update'
end

package 'ruby2.3'
package 'ruby2.3-dev'
package 'bundler'
