require 'spec_helper'

describe 'docker_test::registry' do
  cached(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  before do
    stub_command('/usr/bin/test -f /tmp/registry/tls/ca.pem').and_return(false)
    stub_command('/usr/bin/test -f /tmp/registry/tls/ca-key.pem').and_return(false)
    stub_command('/usr/bin/test -f /tmp/registry/tls/key.pem').and_return(false)
    stub_command('/usr/bin/test -f /tmp/registry/tls/cert.pem').and_return(false)
    stub_command('/usr/bin/test -f /tmp/registry/tls/server-key.pem').and_return(false)
    stub_command('/usr/bin/test -f /tmp/registry/tls/server.pem').and_return(false)
    stub_command('/usr/bin/test -f /tmp/registry/tls/client.csr').and_return(false)
    stub_command('/usr/bin/test -f /tmp/registry/tls/server.csr').and_return(false)
    stub_command("[ ! -z `docker ps -qaf 'name=registry_service$'` ]").and_return(false)
    stub_command("[ ! -z `docker ps -qaf 'name=registry_proxy$'` ]").and_return(false)
    stub_command('netstat -plnt | grep ":5000" && netstat -plnt | grep ":5043"').and_return(false)
  end

  context 'when compiling the recipe' do
    it 'creates directory[/tmp/registry/tls]' do
      expect(chef_run).to create_directory('/tmp/registry/tls').with(
        recursive: true
      )
    end

    it 'runs bash[creating private key for docker server]' do
      expect(chef_run).to run_bash('creating private key for docker server')
    end

    it 'runs bash[generating CA private and public key]' do
      expect(chef_run).to run_bash('generating CA private and public key')
    end

    it 'runs bash[generating certificate request for server]' do
      expect(chef_run).to run_bash('generating certificate request for server')
    end

    it 'creates file[/tmp/registry/tls/server-extfile.cnf]' do
      expect(chef_run).to create_file('/tmp/registry/tls/server-extfile.cnf')
    end

    it 'runs bash[signing request for server]' do
      expect(chef_run).to run_bash('signing request for server')
    end

    it 'runs bash[creating private key for docker client]' do
      expect(chef_run).to run_bash('creating private key for docker client')
    end

    it 'runs bash[generating certificate request for client]' do
      expect(chef_run).to run_bash('generating certificate request for client')
    end

    it 'creates file[/tmp/registry/tls/client-extfile.cnf]' do
      expect(chef_run).to create_file('/tmp/registry/tls/client-extfile.cnf')
    end

    it 'runs bash[signing request for client]' do
      expect(chef_run).to run_bash('signing request for client')
    end

    it 'pulls docker_image[nginx]' do
      expect(chef_run).to pull_docker_image('nginx').with(
        tag: '1.9'
      )
    end

    it 'pulls docker_image[registry]' do
      expect(chef_run).to pull_docker_image('registry').with(
        tag: '2.6.1'
      )
    end

    it 'creates directory[/tmp/registry/auth]' do
      expect(chef_run).to create_directory('/tmp/registry/auth').with(
        recursive: true,
        owner: 'root',
        mode: '0755'
      )
    end

    it 'creates template[/tmp/registry/auth/registry.conf]' do
      expect(chef_run).to create_template('/tmp/registry/auth/registry.conf').with(
        source: 'registry/auth/registry.conf.erb',
        owner: 'root',
        mode: '0755'
      )
    end

    it 'runs execute[copy server cert for registry]' do
      expect(chef_run).to run_execute('copy server cert for registry').with(
        command: 'cp /tmp/registry/tls/server.pem /tmp/registry/auth/server.crt',
        creates: '/tmp/registry/auth/server.crt'
      )
    end

    it 'runs execute[copy server key for registry]' do
      expect(chef_run).to run_execute('copy server key for registry').with(
        command: 'cp /tmp/registry/tls/server-key.pem /tmp/registry/auth/server.key',
        creates: '/tmp/registry/auth/server.key'
      )
    end

    it 'creates template[/tmp/registry/auth/registry.password]' do
      expect(chef_run).to create_template('/tmp/registry/auth/registry.password').with(
        source: 'registry/auth/registry.password.erb',
        owner: 'root',
        mode: '0755'
      )
    end

    it 'runs bash[start docker registry]' do
      expect(chef_run).to run_bash('start docker registry')
    end

    it 'runs bash[start docker registry proxy]' do
      expect(chef_run).to run_bash('start docker registry proxy')
    end

    it 'runs bash[wait for docker registry and proxy]' do
      expect(chef_run).to run_bash('wait for docker registry and proxy')
    end
  end
end
