module MysqlCookbook
  class MysqlClientInstallationPackage < MysqlBase
    # helper methods
    require_relative 'helpers'
    include MysqlCookbook::HelpersBase

    # Resource properties
    resource_name :mysql_client_installation_package
    provides :mysql_client_installation, os: 'linux'
    provides :mysql_client, os: 'linux'

    property :package_name, [String, Array], default: lazy { default_client_package_name }, desired_state: false
    property :package_options, [String, nil], desired_state: false
    property :package_version, [String, nil], default: nil, desired_state: false

    # Actions
    action :create do
      package new_resource.package_name do
        version new_resource.package_version if new_resource.package_version
        options new_resource.package_options if new_resource.package_options
        action :install
      end
    end

    action :delete do
      package new_resource.package_name do
        action :remove
      end
    end
  end
end
