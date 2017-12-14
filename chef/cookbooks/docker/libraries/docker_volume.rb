module DockerCookbook
  class DockerVolume < DockerBase
    require 'docker'

    resource_name :docker_volume

    property :driver, String, desired_state: false
    property :host, [String, nil], default: lazy { default_host }, desired_state: false
    property :opts, [String, Array, nil], desired_state: false
    property :volume, Docker::Volume, desired_state: false
    property :volume_name, String, name_property: true

    load_current_value do
      begin
        with_retries { volume Docker::Volume.get(volume_name, connection) }
      rescue Docker::Error::NotFoundError
        current_value_does_not_exist!
      end
    end

    action :create do
      converge_by "creating volume #{volume_name}" do
        Docker::Volume.create(volume_name, {}, connection)
      end if volume.nil?
    end

    action :remove do
      converge_by "removing volume #{volume_name}" do
        volume.remove
      end unless volume.nil?
    end
  end
end
