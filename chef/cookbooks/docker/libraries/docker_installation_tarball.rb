module DockerCookbook
  class DockerInstallationTarball < DockerBase
    resource_name :docker_installation_tarball

    property :checksum, String, default: lazy { default_checksum }, desired_state: false
    property :source, String, default: lazy { default_source }, desired_state: false
    property :channel, String, default: 'stable', desired_state: false
    property :version, String, default: '18.06.0', desired_state: false

    ##################
    # Property Helpers
    ##################

    def docker_kernel
      node['kernel']['name']
    end

    def docker_arch
      node['kernel']['machine']
    end

    def default_source
      "https://download.docker.com/#{docker_kernel.downcase}/static/#{channel}/#{docker_arch}/docker-#{version}-ce.tgz"
    end

    def default_checksum
      case docker_kernel
      when 'Darwin'
        case version
        when '17.12.0' then 'dc673421e0368c2c970203350a9d0cb739bc498c897e832779369b0b2a9c6192'
        when '18.03.0' then '2d44ed2ac1e24cb22b6e72cb16d74fc9e60245a8ac1d4f79475604b804f46d38'
        when '18.03.1' then 'bbfb9c599a4fdb45523496c2ead191056ff43d6be90cf0e348421dd56bc3dcf0'
        when '18.06.0' then '5489360ae1894375a56255fb821fcf368b33027cd4f4bbaebf5176c05b79f420'
        end
      when 'Linux'
        case version
        when '17.12.0' then '692e1c72937f6214b1038def84463018d8e320c8eaf8530546c84c2f8f9c767d'
        when '18.03.0' then 'e5dff6245172081dbf14285dafe4dede761f8bc1750310156b89928dbf56a9ee'
        when '18.03.1' then '0e245c42de8a21799ab11179a4fce43b494ce173a8a2d6567ea6825d6c5265aa'
        when '18.06.0' then '1c2fa625496465c68b856db0ba850eaad7a16221ca153661ca718de4a2217705'
        end
      end
    end

    #########
    # Actions
    #########

    action :create do
      package 'tar'

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

    ################
    # Action Helpers
    ################
    declare_action_class.class_eval do
      def docker_bin_prefix
        '/usr/bin'
      end

      def docker_bin
        "#{docker_bin_prefix}/docker"
      end

      def docker_tarball
        "#{Chef::Config[:file_cache_path]}/docker-#{new_resource.version}.tgz"
      end
    end
  end
end
