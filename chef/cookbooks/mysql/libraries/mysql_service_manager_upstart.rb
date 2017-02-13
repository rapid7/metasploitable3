module MysqlCookbook
  class MysqlServiceManagerUpstart < MysqlServiceBase
    resource_name :mysql_service_manager_upstart
    provides :mysql_service_manager, platform: 'ubuntu'

    action :create do
      # from base
      create_system_user
      stop_system_service
      create_config
      configure_apparmor
      initialize_database
    end

    action :start do
      template "/usr/sbin/#{mysql_name}-wait-ready" do
        source 'upstart/mysqld-wait-ready.erb'
        owner 'root'
        group 'root'
        mode '0755'
        variables(socket_file: socket_file)
        cookbook 'mysql'
        action :create
      end

      template "/etc/init/#{mysql_name}.conf" do
        source 'upstart/mysqld.erb'
        owner 'root'
        group 'root'
        mode '0644'
        variables(
          defaults_file: defaults_file,
          mysql_name: mysql_name,
          run_group: run_group,
          run_user: run_user,
          socket_dir: socket_dir
        )
        cookbook 'mysql'
        action :create
      end

      service mysql_name do
        provider Chef::Provider::Service::Upstart
        supports status: true
        action [:start]
      end
    end

    action :stop do
      service mysql_name do
        provider Chef::Provider::Service::Upstart
        supports restart: true, status: true
        action [:stop]
      end
    end

    action :restart do
      # With Upstart, restarting the service doesn't behave "as expected".
      # We want the post-start stanzas, which wait until the
      # service is available before returning
      #
      # http://upstart.ubuntu.com/cookbook/#restart
      service mysql_name do
        provider Chef::Provider::Service::Upstart
        action :stop
      end

      service mysql_name do
        provider Chef::Provider::Service::Upstart
        action :start
      end
    end

    action :reload do
      # With Upstart, reload just sends a HUP signal to the process.
      # As far as I can tell, this doesn't work the way it's
      # supposed to, so we need to actually restart the service.
      service mysql_name do
        provider Chef::Provider::Service::Upstart
        action :stop
      end

      service mysql_name do
        provider Chef::Provider::Service::Upstart
        action :start
      end
    end

    declare_action_class.class_eval do
      def stop_system_service
        service system_service_name do
          provider Chef::Provider::Service::Upstart
          supports status: true
          action [:stop, :disable]
        end
      end

      def delete_stop_service
        service mysql_name do
          provider Chef::Provider::Service::Upstart
          action [:disable, :stop]
          only_if { ::File.exist?("#{etc_dir}/init/#{mysql_name}") }
        end
      end
    end
  end
end
