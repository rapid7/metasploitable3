#
# Cookbook:: metasploitable
# Recipe:: readme_app
#
# Copyright:: 2017, Rapid7, All Rights Reserved.
#
#

include_recipe 'metasploitable::ruby23'

package 'git'
package 'nodejs'

directory '/opt/readme_app' do
  mode '0777'
end

bash "clone the readme app and install gems" do
  code <<-EOH
    cd /opt/
    git clone https://github.com/jbarnett-r7/metasploitable3-readme.git readme_app
  EOH
end

cookbook_file '/opt/readme_app/start.sh' do
  source 'readme_app/start.sh'
  mode '0777'
end

cookbook_file '/etc/init/readme_app.conf' do
  source 'readme_app/readme_app.conf'
  mode '0777'
end

service 'readme_app' do
  supports restart: false, start: true, reload: false, status: false
  action [:enable, :start]
end
