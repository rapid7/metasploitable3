name 'apt'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache-2.0'
description 'Configures apt and apt caching.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '7.2.0'

%w(ubuntu debian).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/apt'
issues_url 'https://github.com/chef-cookbooks/apt/issues'
chef_version '>= 13.3'
