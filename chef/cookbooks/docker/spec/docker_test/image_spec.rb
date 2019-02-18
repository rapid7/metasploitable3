require 'spec_helper'

describe 'docker_test::image' do
  cached(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  before do
    stub_command('/usr/bin/test -f /tmp/registry/tls/ca-key.pem').and_return(true)
    stub_command('/usr/bin/test -f /tmp/registry/tls/server-key.pem').and_return(true)
    stub_command('/usr/bin/test -f /tmp/registry/tls/server.csr').and_return(true)
    stub_command('/usr/bin/test -f /tmp/registry/tls/server.pem').and_return(true)
    stub_command('/usr/bin/test -f /tmp/registry/tls/key.pem').and_return(true)
    stub_command('/usr/bin/test -f /tmp/registry/tls/client.csr').and_return(true)
    stub_command('/usr/bin/test -f /tmp/registry/tls/cert.pem').and_return(true)
    stub_command("[ ! -z `docker ps -qaf 'name=registry_service$'` ]").and_return(true)
    stub_command("[ ! -z `docker ps -qaf 'name=registry_proxy$'` ]").and_return(true)
    stub_command('netstat -plnt | grep ":5000" && netstat -plnt | grep ":5043"').and_return(false)
  end

  context 'testing default action, default properties' do
    it 'pulls docker_image[hello-world]' do
      expect(chef_run).to pull_docker_image('hello-world').with(
        api_retries: 3,
        destination: nil,
        force: false,
        nocache: false,
        noprune: false,
        read_timeout: 120,
        repo: 'hello-world',
        rm: true,
        source: nil,
        tag: 'latest',
        write_timeout: nil
      )
    end
  end

  context 'testing non-default name attribute containing a single quote' do
    it "pulls docker_image[Tom's container]" do
      expect(chef_run).to pull_docker_image("Tom's container").with(
        repo: 'tduffield/testcontainerd'
      )
    end
  end

  context 'testing the :pull action' do
    it 'pulls docker_image[busybox]' do
      expect(chef_run).to pull_docker_image('busybox')
    end
  end

  context 'testing using pull_if_missing' do
    it 'pull_if_missing docker_image[debian]' do
      expect(chef_run).to pull_if_missing_docker_image('debian')
    end
  end

  context 'testing specifying a tag and read/write timeouts' do
    it 'pulls docker_image[alpine]' do
      expect(chef_run).to pull_docker_image('alpine').with(
        tag: '3.1',
        read_timeout: 60,
        write_timeout: 60
      )
    end
  end

  context 'testing the host property' do
    it 'pulls docker_image[alpine-localhost]' do
      expect(chef_run).to pull_docker_image('alpine-localhost').with(
        repo: 'alpine',
        tag: '2.7',
        host: 'tcp://127.0.0.1:2376'
      )
    end
  end

  context 'testing :remove action' do
    it 'runs execute[pull vbatts/slackware]' do
      expect(chef_run).to run_execute('pull vbatts/slackware').with(
        command: 'docker pull vbatts/slackware ; touch /marker_image_slackware',
        creates: '/marker_image_slackware'
      )
    end

    it 'removes docker_image[vbatts/slackware]' do
      expect(chef_run).to remove_docker_image('vbatts/slackware')
    end
  end

  context 'testing :save action' do
    it 'saves docker_image[save hello-world]' do
      expect(chef_run).to save_docker_image('save hello-world').with(
        repo: 'hello-world',
        destination: '/hello-world.tar'
      )
    end
  end

  context 'testing :load action' do
    it 'pulls docker_image[cirros]' do
      expect(chef_run).to pull_docker_image('cirros')
    end

    it 'saves docker_image[save cirros]' do
      expect(chef_run).to save_docker_image('save cirros').with(
        destination: '/cirros.tar'
      )
    end

    it 'removes docker_image[remove cirros]' do
      expect(chef_run).to remove_docker_image('remove cirros').with(
        repo: 'cirros'
      )
    end

    it 'loads docker_image[load cirros]' do
      expect(chef_run).to load_docker_image('load cirros').with(
        source: '/cirros.tar'
      )
    end

    it 'creates file[/marker_image_image-1]' do
      expect(chef_run).to create_file('/marker_load_cirros-1')
    end
  end

  context 'testing the :build action from Dockerfile' do
    it 'creates directory[/usr/local/src/container1]' do
      expect(chef_run).to create_directory('/usr/local/src/container1')
    end

    it 'creates cookbook_file[/usr/local/src/container1/Dockerfile]' do
      expect(chef_run).to create_cookbook_file('/usr/local/src/container1/Dockerfile').with(
        source: 'Dockerfile_1'
      )
    end

    it 'build docker_image[someara/image-1]' do
      expect(chef_run).to build_docker_image('someara/image-1').with(
        tag: 'v0.1.0',
        source: '/usr/local/src/container1/Dockerfile',
        force: true
      )
    end

    it 'creates file[/marker_image_image-1]' do
      expect(chef_run).to create_file('/marker_image_image-1')
    end
  end

  context 'testing the :build action from directory' do
    it 'creates directory[/usr/local/src/container2]' do
      expect(chef_run).to create_directory('/usr/local/src/container2')
    end

    it 'creates file[/usr/local/src/container2/foo.txt]' do
      expect(chef_run).to create_file('/usr/local/src/container2/foo.txt').with(
        content: 'Dockerfile_2 contains ADD for this file'
      )
    end

    it 'creates cookbook_file[/usr/local/src/container2/Dockerfile]' do
      expect(chef_run).to create_cookbook_file('/usr/local/src/container2/Dockerfile').with(
        source: 'Dockerfile_2'
      )
    end

    it 'build_if_missing docker_image[someara/image.2]' do
      expect(chef_run).to build_if_missing_docker_image('someara/image.2').with(
        tag: 'v0.1.0',
        source: '/usr/local/src/container2'
      )
    end
  end

  context 'testing the :build action from a tarball' do
    it 'creates cookbook_file[/usr/local/src/image_3.tar]' do
      expect(chef_run).to create_cookbook_file('/usr/local/src/image_3.tar').with(
        source: 'image_3.tar'
      )
    end

    it 'build_if_missing docker_image[image_3]' do
      expect(chef_run).to build_if_missing_docker_image('image_3').with(
        tag: 'v0.1.0',
        source: '/usr/local/src/image_3.tar'
      )
    end
  end

  context 'testing the :import action' do
    it 'imports docker_image[hello-again]' do
      expect(chef_run).to import_docker_image('hello-again').with(
        tag: 'v0.1.0',
        source: '/hello-world.tar'
      )
    end
  end

  context 'testing images with dots and dashes in the name' do
    it 'pulls docker_image[someara/name-w-dashes]' do
      expect(chef_run).to pull_docker_image('someara/name-w-dashes')
    end

    it 'pulls docker_image[someara/name.w.dots]' do
      expect(chef_run).to pull_docker_image('someara/name.w.dots')
    end
  end

  context 'when setting up a local registry' do
    it 'includes the "docker_test::registry" recipe' do
      expect(chef_run).to include_recipe('docker_test::registry')
    end
  end

  context 'testing pushing to a private registry' do
    it 'tags docker_tag[private repo tag for name-w-dashes:v1.0.1]' do
      expect(chef_run).to tag_docker_tag('private repo tag for name-w-dashes:v1.0.1').with(
        target_repo: 'hello-again',
        target_tag: 'v0.1.0',
        to_repo: 'localhost:5043/someara/name-w-dashes',
        to_tag: 'latest'
      )
    end

    it 'tags docker_tag[private repo tag for name.w.dots]' do
      expect(chef_run).to tag_docker_tag('private repo tag for name.w.dots').with(
        target_repo: 'busybox',
        target_tag: 'latest',
        to_repo: 'localhost:5043/someara/name.w.dots',
        to_tag: 'latest'
      )
    end

    it 'pushes docker_image[localhost:5043/someara/name-w-dashes]' do
      expect(chef_run).to push_docker_image('localhost:5043/someara/name-w-dashes')
    end

    it 'creates file[/marker_image_private_name-w-dashes]' do
      expect(chef_run).to create_file('/marker_image_private_name-w-dashes')
    end

    it 'pushes docker_image[localhost:5043/someara/name.w.dots]' do
      expect(chef_run).to push_docker_image('localhost:5043/someara/name.w.dots')
    end

    it 'pushes docker_image[localhost:5043/someara/name.w.dots] with tag v0.1.0' do
      expect(chef_run).to push_docker_image('localhost:5043/someara/name.w.dots').with(
        tag: 'v0.1.0'
      )
    end

    it 'login docker_registry[localhost:5043]' do
      expect(chef_run).to login_docker_registry('localhost:5043').with(
        username: 'testuser',
        password: 'testpassword',
        email: 'alice@computers.biz'
      )
    end

    it 'creates file[/marker_image_private_name.w.dots]' do
      expect(chef_run).to create_file('/marker_image_private_name.w.dots')
    end
  end

  context 'testing pulling from public Dockerhub after being authenticated to a private one' do
    it 'pulls docker_image[fedora]' do
      expect(chef_run).to pull_docker_image('fedora')
    end
  end
end
