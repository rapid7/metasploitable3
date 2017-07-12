module DockerCookbook
  class DockerInstallationBinary < DockerBase
    require_relative 'helpers_installation_binary'

    include DockerHelpers::InstallationBinary

    #####################
    # Resource properties
    #####################
    resource_name :docker_installation_binary

    property :checksum, String, default: lazy { default_checksum }, desired_state: false
    property :source, String, default: lazy { default_source }, desired_state: false
    property :version, String, default: lazy { default_version }, desired_state: false

    default_action :create

    #########
    # Actions
    #########

    action :create do
      # Pull a precompiled binary off the network
      remote_file docker_bin do
        source new_resource.source
        checksum new_resource.checksum
        owner 'root'
        group 'root'
        mode '0755'
        action :create
      end
    end

    action :delete do
      file docker_bin do
        action :delete
      end
    end
  end
end
