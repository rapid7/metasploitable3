module DockerCookbook
  class DockerInstallationScript < DockerBase
    #####################
    # Resource properties
    #####################
    resource_name :docker_installation_script

    provides :docker_installation, os: 'linux'

    property :repo, %w(main test experimental), default: 'main', desired_state: false
    property :script_url, String, default: lazy { default_script_url }, desired_state: false

    default_action :create

    ################
    # helper methods
    ################

    def default_script_url
      case repo
      when 'main'
        'https://get.docker.com/'
      when 'test'
        'https://test.docker.com/'
      when 'experimental'
        'https://experimental.docker.com/'
      end
    end

    #########
    # Actions
    #########

    action :create do
      package 'curl' do
        action :install
      end

      execute 'install docker' do
        command "curl -sSL #{script_url} | sh"
        creates '/usr/bin/docker'
      end
    end

    action :delete do
      package 'docker-engine' do
        action :remove
      end
    end
  end
end
