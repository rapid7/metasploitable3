#
# Cookbook:: metasploitable
# Recipe:: nodejs
#
# Copyright:: 2017, Rapid7, All Rights Reserved.
#
#

execute "apt-get update" do
  command "apt-get update"
end

package 'nodejs'
package 'npm'
