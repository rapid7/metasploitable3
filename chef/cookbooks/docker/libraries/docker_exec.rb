module DockerCookbook
  class DockerExec < DockerBase
    resource_name :docker_exec

    property :host, [String, nil], default: lazy { ENV['DOCKER_HOST'] }, desired_state: false
    property :command, Array
    property :container, String
    property :timeout, Numeric, default: 60, desired_state: false
    property :container_obj, Docker::Container, desired_state: false

    alias_method :cmd, :command

    action :run do
      converge_by "executing #{new_resource.command} on #{new_resource.container}" do
        with_retries { new_resource.container_obj Docker::Container.get(new_resource.container, {}, connection) }
        new_resource.container_obj.exec(new_resource.command, wait: new_resource.timeout)
      end
    end
  end
end
