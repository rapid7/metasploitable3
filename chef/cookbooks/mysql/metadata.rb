name 'mysql'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache-2.0'
description 'Provides mysql_service, mysql_config, and mysql_client resources'
version '8.5.1'

%w(redhat centos scientific oracle).each do |el|
  supports el, '>= 6.0'
end

supports 'amazon'
supports 'fedora'
supports 'debian', '>= 7.0'
supports 'ubuntu', '>= 12.04'

supports 'opensuse', '>= 13.0'
supports 'opensuseleap'
supports 'suse', '>= 12.0'

source_url 'https://github.com/chef-cookbooks/mysql'
issues_url 'https://github.com/chef-cookbooks/mysql/issues'
chef_version '>= 12.7' if respond_to?(:chef_version)
