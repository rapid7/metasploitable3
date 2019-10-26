mysql_server_installation_package 'default' do
  version node['mysql']['version']
  action :install
end

mysql_service_manager 'default' do
  version node['mysql']['version']
  action [:create, :start]
end
