#
# Cookbook:: metasploitable
# Recipe:: ruby23
#
# Copyright:: 2017, Rapid7, All Rights Reserved.
#
#

apt_repository 'rvm' do
  uri 'ppa:brightbox/ruby-ng'
end

execute 'apt-get update' do
  command 'apt-get update'
end

package 'ruby2.3'
package 'ruby2.3-dev'
package 'bundler'
