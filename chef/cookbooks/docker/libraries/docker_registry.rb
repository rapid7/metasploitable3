module DockerCookbook
  class DockerRegistry < DockerBase
    resource_name :docker_registry

    property :email, String

    property :password, String,
             sensitive: true

    property :serveraddress, String,
             name_property: true

    property :username, String

    property :host, [String, nil], default: lazy { ENV['DOCKER_HOST'] }, desired_state: false

    action :login do
      tries = new_resource.api_retries

      registry_host = parse_registry_host(new_resource.serveraddress)

      (node.run_state['docker_auth'] ||= {})[registry_host] = {
        'serveraddress' => registry_host,
        'username' => new_resource.username,
        'password' => new_resource.password,
        'email' => new_resource.email,
      }

      begin
        Docker.connection.post(
          '/auth', {},
          body: node.run_state['docker_auth'][registry_host].to_json
        )
      rescue Docker::Error::ServerError, Docker::Error::UnauthorizedError
        raise Docker::Error::AuthenticationError, "#{new_resource.username} failed to authenticate with #{new_resource.serveraddress}" if (tries -= 1) == 0
        retry
      end

      true
    end
  end
end
