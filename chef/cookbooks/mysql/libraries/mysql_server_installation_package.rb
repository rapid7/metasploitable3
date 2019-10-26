module MysqlCookbook
  class MysqlServerInstallationPackage < MysqlBase
    # Resource properties
    resource_name :mysql_server_installation_package
    provides :mysql_server_installation, os: 'linux'

    property :package_name, String, default: lazy { default_server_package_name }, desired_state: false
    property :package_options, [String, nil], desired_state: false
    property :package_version, [String, nil], default: nil, desired_state: false

    # helper methods
    require_relative 'helpers'
    include MysqlCookbook::HelpersBase

    # Actions
    action :install do
      package new_resource.package_name do
        version new_resource.package_version if new_resource.package_version
        options new_resource.package_options if new_resource.package_options
        notifies :install, 'package[perl-Sys-Hostname-Long]', :immediately if platform_family?('suse')
        notifies :run, 'execute[Initial DB setup script]', :immediately if platform_family?('suse')
        action :install
      end

      package 'perl-Sys-Hostname-Long' do
        action :nothing
      end

      execute 'Initial DB setup script' do
        environment 'INSTANCE' => new_resource.name
        command '/usr/lib/mysql/mysql-systemd-helper install'
        action :nothing
      end
    end

    action :delete do
      package new_resource.package_name do
        action :remove
      end
    end
  end
end
