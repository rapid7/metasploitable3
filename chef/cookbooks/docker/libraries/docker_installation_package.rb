module DockerCookbook
  class DockerInstallationPackage < DockerBase
    require_relative 'helpers_installation_package'

    include DockerHelpers::InstallationPackage

    # Resource properties
    resource_name :docker_installation_package

    provides :docker_installation, platform: 'amazon'

    property :package_name, String, default: lazy { default_package_name }, desired_state: false
    property :package_version, String, default: lazy { version_string(version) }, desired_state: false
    property :version, String, default: lazy { default_docker_version }, desired_state: false
    property :package_options, String, desired_state: false

    # Actions
    action :create do
      package package_name do
        version package_version
        options package_options
        action :install
      end
    end

    action :delete do
      package package_name do
        action :remove
      end
    end
  end
end
