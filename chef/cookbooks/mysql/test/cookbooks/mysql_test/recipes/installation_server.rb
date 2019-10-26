apt_update 'update'

def configure_package_repositories
  # we need to enable the yum-mysql-community repository to get packages
  return unless %w(rhel fedora).include? node['platform_family']
  case node['mysql']['version']
  when '5.5'
    return if node['platform_family'] == 'fedora'
    include_recipe 'yum-mysql-community::mysql55'
  when '5.6'
    include_recipe 'yum-mysql-community::mysql56'
  when '5.7'
    include_recipe 'yum-mysql-community::mysql57'
  end
end

configure_package_repositories

mysql_server_installation_package 'default' do
  version node['mysql']['version']
  action :install
end
