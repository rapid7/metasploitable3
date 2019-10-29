name 'metasploitable'
maintainer 'Rapid7'
maintainer_email ''
license 'BSD-3-clause'
description 'Installs/Configures metasploitable3'
long_description 'Installs/Configures metasploitable3'
version '0.1.0'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/metasploitable3/issues' if respond_to?(:issues_url)

# The `source_url` points to the development reposiory for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/metasploitable3' if respond_to?(:source_url)

depends 'apt', '~> 7.2'
depends 'docker', '~> 4.9'
depends 'mysql', '~> 8.3'
