module DockerCookbook
  class DockerInstallationTarball < DockerBase
    require_relative 'helpers_installation_tarball'

    include DockerHelpers::InstallationTarball

    #####################
    # Resource properties
    #####################
    resource_name :docker_installation_tarball

    property :checksum, String, default: lazy { default_checksum }, desired_state: false
    property :source, String, default: lazy { default_source }, desired_state: false
    property :version, String, default: lazy { default_version }, desired_state: false

    default_action :create

    #########
    # Actions
    #########

    action :create do
      # Pull a precompiled binary off the network
      remote_file docker_tarball do
        source new_resource.source
        checksum new_resource.checksum
        owner 'root'
        group 'root'
        mode '0755'
        action :create
        notifies :run, 'execute[extract tarball]', :immediately
      end

      execute 'extract tarball' do
        action :nothing
        command "tar -xzf #{docker_tarball} --strip-components=1 -C #{docker_bin_prefix}"
        creates docker_bin
      end
    end

    action :delete do
      file docker_bin do
        action :delete
      end
    end
  end
end
