#
# Cookbook:: metasploitable
# Recipe:: readme_app
#
# Copyright:: 2017, Rapid7, All Rights Reserved.
#
#

include_recipe 'metasploitable::ruby23'
include_recipe 'metasploitable::nodejs'

package 'git'

git '/opt/readme_app' do
    repository 'https://github.com/jbarnett-r7/metasploitable3-readme.git'
    action :checkout
end

directory '/opt/readme_app' do
  owner 'chewbacca'
  group 'users'
  mode '0644'
end

template '/opt/readme_app/start.sh' do
  source 'readme_app/start.sh.erb'
end

cookbook_file '/etc/init/readme_app.conf' do
  source 'readme_app/readme_app.conf'
  mode '0644'
end

bash 'set permissions' do
  cwd '/opt/readme_app'
  code <<-EOH
    chown -R chewbacca:users .
    git ls-files | xargs chmod 0644
    git ls-files | xargs -n 1 dirname | uniq | xargs chmod 755
    chmod 0755 ./start.sh
  EOH
end

service 'readme_app' do
  supports restart: false, start: true, reload: false, status: false
  action [:enable, :start]
end
