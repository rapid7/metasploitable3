#
# Cookbook:: metasploitable
# Recipe:: readme_app
#
# Copyright:: 2017, Rapid7, All Rights Reserved.
#
#

include_recipe 'metasploitable::ruby23'

package 'git'

directory '/opt/readme_app' do
  mode '0777'
end

bash "clone the readme app and install gems" do
  code <<-EOH
    cd /opt/
    git clone https://github.com/jbarnett-r7/metasploitable3-readme.git readme_app
    cd readme_app
    bundle install
  EOH
end

cookbook_file '/etc/init.d/readme_app' do
  source 'readme_app/readme_app'
  mode '760'
end

service 'readme_app' do
  action [:enable, :start]
end
