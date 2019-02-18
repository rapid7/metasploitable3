require 'spec_helper'

require_relative '../../libraries/docker_base'
require_relative '../../libraries/docker_registry'

describe 'docker_registry' do
  step_into :docker_registry
  platform 'ubuntu'

  # Info returned by docker api
  # https://docs.docker.com/engine/api/v1.39/#section/Authentication
  let(:auth) do
    {
      'identitytoken' => '9cbafc023786cd7...',
    }.to_json
  end

  before do
    # Ensure docker api calls are mocked
    # It is low level much easier to do in Excon
    # Plus, the low level mock allows testing this cookbook
    # for multiple docker apis and docker-api gems
    # https://github.com/excon/excon#stubs
    Excon.defaults[:mock] = true
    Excon.stub({ method: :post, path: '/v1.16/auth' }, body: auth, status: 200)
  end

  context 'logs into a docker registry with default options' do
    recipe do
      docker_registry 'chefspec_custom_registry' do
        email 'chefspec_email'
        password 'chefspec_password'
        username 'chefspec_username'
      end
    end
    it {
      expect { chef_run }.to_not raise_error
      expect(chef_run).to login_docker_registry('chefspec_custom_registry').with(
        email: 'chefspec_email',
        password: 'chefspec_password',
        username: 'chefspec_username',
        host: nil
      )
    }
  end

  context 'logs into a docker registry with host' do
    recipe do
      docker_registry 'chefspec_custom_registry' do
        email 'chefspec_email'
        password 'chefspec_password'
        username 'chefspec_username'
        host 'chefspec_host'
      end
    end
    it {
      expect { chef_run }.to_not raise_error
      expect(chef_run).to login_docker_registry('chefspec_custom_registry').with(
        email: 'chefspec_email',
        password: 'chefspec_password',
        username: 'chefspec_username',
        host: 'chefspec_host'
      )
    }
  end

  context 'logs into a docker registry with host environment variable' do
    recipe do
      docker_registry 'chefspec_custom_registry' do
        email 'chefspec_email'
        password 'chefspec_password'
        username 'chefspec_username'
      end
    end
    it {
      # Set the environment variable
      stub_const 'ENV', ENV.to_h.merge('DOCKER_HOST' => 'chefspec_host_environment_variable')

      expect { chef_run }.to_not raise_error
      expect(chef_run).to login_docker_registry('chefspec_custom_registry').with(
        email: 'chefspec_email',
        password: 'chefspec_password',
        username: 'chefspec_username',
        host: 'chefspec_host_environment_variable'
      )
    }
  end
end
