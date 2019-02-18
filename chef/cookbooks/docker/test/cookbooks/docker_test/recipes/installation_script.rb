docker_installation_script 'default' do
  repo node['docker']['repo']
  action :create
end
