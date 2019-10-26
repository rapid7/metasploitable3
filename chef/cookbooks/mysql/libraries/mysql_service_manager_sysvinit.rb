module MysqlCookbook
  class MysqlServiceManagerSysvinit < MysqlServiceBase
    resource_name :mysql_service_manager_sysvinit

    provides :mysql_service_manager, os: 'linux'

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
          error_log: new_resource.error_log,
          mysql_name: mysql_name,
          mysqladmin_bin: mysqladmin_bin,
          mysqld_safe_bin: mysqld_safe_bin,
          pid_file: new_resource.pid_file,
          scl_name: scl_name
        )
        cookbook 'mysql'
        action :create
      end

      service mysql_name do
        supports restart: true, status: true
        action [:enable, :start]
      end
    end

    action :stop do
      service mysql_name do
        supports restart: true, status: true
        action [:stop]
      end
    end

    action :restart do
      service mysql_name do
        supports restart: true
        action :restart
      end
    end

    action :reload do
      service mysql_name do
        action :reload
      end
    end

    action_class do
      def stop_system_service
        service system_service_name do
          supports status: true
          action [:stop, :disable]
        end
      end

      def delete_stop_service
        service mysql_name do
          supports status: true
          action [:disable, :stop]
          only_if { ::File.exist?("#{etc_dir}/init.d/#{mysql_name}") }
        end
      end
    end
  end
end
