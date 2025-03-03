#
# Cookbook:: metasploitable
# Recipe:: docker
#

docker_service 'default' do
  install_method 'tarball'
  version '18.06.0'
  action [:create, :start]
  group 'docker'
end

group 'docker' do
  action [:create, :modify]
  append true
  members node[:metasploitable][:docker_users]
end
