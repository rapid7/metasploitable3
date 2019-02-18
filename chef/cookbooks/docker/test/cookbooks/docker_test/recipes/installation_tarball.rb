docker_installation_tarball 'default' do
  version node['docker']['version']
  action :create
end
