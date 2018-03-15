module MysqlCookbook
  class MysqlServiceManagerSysvinit < MysqlServiceBase
    resource_name :mysql_service_manager_sysvinit

    provides :mysql_service_manager, platform: %w(redhat centos scientific oracle) do |node| # ~FC005
      node['platform_version'].to_f <= 7.0
    end

    provides :mysql_service_manager, platform: 'suse'
    provides :mysql_service_manager, platform: 'debian'

    action :create do
      # from base
      create_system_user
      stop_system_service
      create_config
      initialize_database
      configure_apparmor
    end

    action :start do
      template "/etc/init.d/#{mysql_name}" do
        source 'sysvinit/mysqld.erb'
        owner 'root'
        group 'root'
        mode '0755'
        variables(
          config: new_resource,
          defaults_file: defaults_file,
          error_log: error_log,
          mysql_name: mysql_name,
          mysqladmin_bin: mysqladmin_bin,
          mysqld_safe_bin: mysqld_safe_bin,
          pid_file: pid_file,
          scl_name: scl_name
        )
        cookbook 'mysql'
        action :create
      end

      service mysql_name do
        provider Chef::Provider::Service::Init::Redhat if node['platform_family'] == 'redhat'
        provider Chef::Provider::Service::Init::Insserv if node['platform_family'] == 'debian'
        supports restart: true, status: true
        action [:enable, :start]
      end
    end

    action :stop do
      service mysql_name do
        provider Chef::Provider::Service::Init::Redhat if node['platform_family'] == 'redhat'
        provider Chef::Provider::Service::Init::Insserv if node['platform_family'] == 'debian'
        supports restart: true, status: true
        action [:stop]
      end
    end

    action :restart do
      service mysql_name do
        provider Chef::Provider::Service::Init::Redhat if node['platform_family'] == 'redhat'
        provider Chef::Provider::Service::Init::Insserv if node['platform_family'] == 'debian'
        supports restart: true
        action :restart
      end
    end

    action :reload do
      service mysql_name do
        provider Chef::Provider::Service::Init::Redhat if node['platform_family'] == 'redhat'
        provider Chef::Provider::Service::Init::Insserv if node['platform_family'] == 'debian'
        action :reload
      end
    end

    declare_action_class.class_eval do
      def stop_system_service
        service system_service_name do
          provider Chef::Provider::Service::Init::Redhat if node['platform_family'] == 'redhat'
          provider Chef::Provider::Service::Init::Insserv if node['platform_family'] == 'debian'
          supports status: true
          action [:stop, :disable]
        end
      end

      def delete_stop_service
        service mysql_name do
          provider Chef::Provider::Service::Init::Redhat if node['platform_family'] == 'redhat'
          provider Chef::Provider::Service::Init::Insserv if node['platform_family'] == 'debian'
          supports status: true
          action [:disable, :stop]
          only_if { ::File.exist?("#{etc_dir}/init.d/#{mysql_name}") }
        end
      end
    end
  end
end
