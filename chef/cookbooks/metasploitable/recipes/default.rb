#
# Cookbook:: metasploitable
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe 'metasploitable::root_certs'
include_recipe 'metasploitable::vagrant_ssh'

include_recipe 'metasploitable::apache_struts'
include_recipe 'metasploitable::axis2'
include_recipe 'metasploitable::backdoors'
include_recipe 'metasploitable::create_users'
include_recipe 'metasploitable::disable_auto_logon'
include_recipe 'metasploitable::elasticsearch'
include_recipe 'metasploitable::enable_rdp'
include_recipe 'metasploitable::flags'
include_recipe 'metasploitable::ftp'
include_recipe 'metasploitable::glassfish'
include_recipe 'metasploitable::jenkins'
include_recipe 'metasploitable::jmx'
include_recipe 'metasploitable::mysql'
include_recipe 'metasploitable::password_setting'
include_recipe 'metasploitable::rails'
include_recipe 'metasploitable::webdav'
include_recipe 'metasploitable::wordpress'

include_recipe 'metasploitable::cleaner'
