module MysqlCookbook
  class MysqlServiceBase < MysqlBase
    property :bind_address, String, desired_state: false
    property :charset, String, default: 'utf8', desired_state: false
    property :data_dir, String, default: lazy { default_data_dir }, desired_state: false
    property :error_log, String, default: lazy { default_error_log }, desired_state: false
    property :initial_root_password, String, default: 'ilikerandompasswords', desired_state: false
    property :instance, String, name_property: true, desired_state: false
    property :mysqld_options, Hash, default: {}, desired_state: false
    property :pid_file, String, default: lazy { default_pid_file }, desired_state: false
    property :port, [String, Integer], default: '3306', desired_state: false
    property :socket, String, default: lazy { default_socket_file }, desired_state: false
    property :tmp_dir, String, desired_state: false

    alias socket_file socket

    require_relative 'helpers'
    include MysqlCookbook::HelpersBase

    # action class methods are available within the actions and work as if the coded
    # was inline the action. No messing with classes or passing in the new_resource
    action_class do
      def create_system_user
        group 'mysql' do
          action :create
        end

        user 'mysql' do
          gid 'mysql'
          action :create
        end
      end

      def create_config
        # require 'pry' ; binding.pry

        # Yak shaving secion. Account for random errata.
        #
        # Turns out that mysqld is hard coded to try and read
        # /etc/mysql/my.cnf, and its presence causes problems when
        # setting up multiple services.
        file "#{prefix_dir}/etc/mysql/my.cnf" do
          action :delete
        end

        file "#{prefix_dir}/etc/my.cnf" do
          action :delete
        end

        # mysql_install_db is broken on 5.6.13
        link "#{prefix_dir}/usr/share/my-default.cnf" do
          to "#{etc_dir}/my.cnf"
          not_if { ::File.exist? "#{prefix_dir}/usr/share/my-default.cnf" } # FIXME: Chef bug?
          action :create
        end

        # Support directories
        directory etc_dir do
          owner new_resource.run_user
          group new_resource.run_group
          mode '0750'
          recursive true
          action :create
        end

        directory new_resource.include_dir do
          owner new_resource.run_user
          group new_resource.run_group
          mode '0750'
          recursive true
          action :create
        end

        directory run_dir do
          owner new_resource.run_user
          group new_resource.run_group
          mode '0755'
          recursive true
          action :create
        end

        directory log_dir do
          owner new_resource.run_user
          group new_resource.run_group
          mode '0750'
          recursive true
          action :create
        end

        directory new_resource.data_dir do
          owner new_resource.run_user
          group new_resource.run_group
          mode '0750'
          recursive true
          action :create
        end

        # Main configuration file
        template "#{etc_dir}/my.cnf" do
          source 'my.cnf.erb'
          cookbook 'mysql'
          owner new_resource.run_user
          group new_resource.run_group
          mode '0600'
          variables(config: new_resource)
          action :create
        end
      end

      def initialize_database
        # initialize database and create initial records
        bash "#{new_resource.name} initial records" do
          code init_records_script
          umask '022'
          returns [0, 1, 2] # facepalm
          not_if "/usr/bin/test -f #{new_resource.data_dir}/mysql/user.frm"
          action :run
        end
      end

      def delete_support_directories
        # Stop the service before removing support directories
        delete_stop_service

        directory etc_dir do
          recursive true
          action :delete
        end

        directory run_dir do
          recursive true
          action :delete
        end

        directory log_dir do
          recursive true
          action :delete
        end
      end

      #
      # Platform specific bits
      #
      def configure_apparmor
        # Do not add these resource if inside a container
        # Only valid on Ubuntu
        return if ::File.exist?('/.dockerenv') || ::File.exist?('/.dockerinit') || node['platform'] != 'ubuntu'

        # Apparmor
        package 'apparmor' do
          action :install
        end

        directory '/etc/apparmor.d/local/mysql' do
          owner 'root'
          group 'root'
          mode '0755'
          recursive true
          action :create
        end

        template '/etc/apparmor.d/local/usr.sbin.mysqld' do
          cookbook 'mysql'
          source 'apparmor/usr.sbin.mysqld-local.erb'
          owner 'root'
          group 'root'
          mode '0644'
          action :create
          notifies :restart, "service[#{new_resource.instance} apparmor]", :immediately
        end

        template '/etc/apparmor.d/usr.sbin.mysqld' do
          cookbook 'mysql'
          source 'apparmor/usr.sbin.mysqld.erb'
          owner 'root'
          group 'root'
          mode '0644'
          action :create
          notifies :restart, "service[#{new_resource.instance} apparmor]", :immediately
        end

        template "/etc/apparmor.d/local/mysql/#{new_resource.instance}" do
          cookbook 'mysql'
          source 'apparmor/usr.sbin.mysqld-instance.erb'
          owner 'root'
          group 'root'
          mode '0644'
          variables(
            config: new_resource,
            mysql_name: mysql_name
          )
          action :create
          notifies :restart, "service[#{new_resource.instance} apparmor]", :immediately
        end

        service "#{new_resource.instance} apparmor" do
          service_name 'apparmor'
          action :nothing
        end
      end
    end
  end
end
