module DockerCookbook
  class DockerRegistry < DockerBase
    require 'docker'
    require_relative 'helpers_auth'

    resource_name :docker_registry

    property :email, [String, nil]
    property :password, [String, nil]
    property :serveraddress, [String, nil], name_property: true
    property :username, [String, nil]

    action :login do
      tries = api_retries

      registry_host = parse_registry_host(serveraddress)

      (node.run_state['docker_auth'] ||= {})[registry_host] = {
        'serveraddress' => registry_host,
        'username' => username,
        'password' => password,
        'email' => email,
      }

      begin
        Docker.connection.post(
          '/auth', {},
          body: node.run_state['docker_auth'][registry_host].to_json
        )
      rescue Docker::Error::ServerError, Docker::Error::UnauthorizedError
        raise Docker::Error::AuthenticationError, "#{username} failed to authenticate with #{serveraddress}" if (tries -= 1) == 0
        retry
      end

      true
    end
  end
end
