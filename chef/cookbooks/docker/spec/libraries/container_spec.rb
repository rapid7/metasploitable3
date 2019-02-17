require 'spec_helper'
require 'chef'
require 'excon'

require_relative '../../libraries/docker_base'
require_relative '../../libraries/docker_container'

describe 'docker_container' do
  step_into :docker_container
  platform 'ubuntu'

  # Info returned by docker api
  # https://docs.docker.com/engine/api/v1.39/#tag/Container
  let(:container) do
    {
      'Id' => '123456789',
      'IPAddress' => '10.0.0.1',
      'Image' => 'ubuntu:bionic',
      'Names' => ['/hello_world'],
      'Config' => { 'Labels' => {} },
      'HostConfig' => { 'RestartPolicy' => { 'Name' => 'unless-stopped',
                                             'MaximumRetryCount' => 1 },
                        'Binds' => [],
                        'ReadonlyRootfs' => false },
      'State' => 'not running',
      'Warnings' => [],
    }.to_json
  end
  # https://docs.docker.com/engine/api/v1.39/#tag/Image
  let(:image) do
    { 'Id' => 'bf119e2',
      'Repository' => 'ubuntu', 'Tag' => 'bionic',
      'Created' => 1_364_102_658, 'Size' => 24_653,
      'VirtualSize' => 180_116_135,
      'Config' => { 'Labels' => {} } }.to_json
  end
  # https://docs.docker.com/engine/api/v1.39/#operation/SystemInfo
  let(:info) do
    { 'Labels' => {} }.to_json
  end
  # https://docs.docker.com/engine/api/v1.39/#operation/ContainerCreate
  let(:create) do
    {
      'Id' => 'e90e34656806',
      'Warnings' => [],
    }.to_json
  end

  before do
    # Ensure docker api calls are mocked
    # It is low level much easier to do in Excon
    # Plus, the low level mock allows testing this cookbook
    # for multiple docker apis and docker-api gems
    # https://github.com/excon/excon#stubs
    Excon.defaults[:mock] = true
    Excon.stub({ method: :get, path: '/v1.16/containers/hello_world/json' }, body: container, status: 200)
    Excon.stub({ method: :get, path: '/v1.16/images/ubuntu:bionic/json' }, body: image, status: 200)
    Excon.stub({ method: :get, path: '/v1.16/info' }, body: info, status: 200)
    Excon.stub({ method: :delete, path: '/v1.16/containers/123456789' }, body: '', status: 200)
    Excon.stub({ method: :post, path: '/v1.16/containers/create' }, body: create, status: 200)
    Excon.stub({ method: :get, path: '/v1.16/containers/123456789/start' }, body: '', status: 200)
  end

  context 'creates a docker container with default options' do
    recipe do
      docker_container 'hello_world' do
        tag 'ubuntu:latest'
        action :create
      end
    end

    it {
      expect { chef_run }.to_not raise_error
      expect(chef_run).to create_docker_container('hello_world').with(
        tag: 'ubuntu:latest',
        create_options: { 'name' => 'hello_world', 'Image' => 'hello_world:ubuntu:latest', 'Labels' => {}, 'Cmd' => nil, 'AttachStderr' => false, 'AttachStdin' => false, 'AttachStdout' => false, 'Domainname' => '', 'Entrypoint' => nil, 'Env' => [], 'ExposedPorts' => {}, 'Hostname' => nil, 'MacAddress' => nil, 'NetworkDisabled' => false, 'OpenStdin' => false, 'StdinOnce' => false, 'Tty' => false, 'User' => '', 'Volumes' => {}, 'WorkingDir' => '', 'HostConfig' => { 'Binds' => nil, 'CapAdd' => nil, 'CapDrop' => nil, 'CgroupParent' => '', 'CpuShares' => 0, 'CpusetCpus' => '', 'Devices' => [], 'Dns' => [], 'DnsSearch' => [], 'ExtraHosts' => nil, 'IpcMode' => '', 'Init' => nil, 'KernelMemory' => 0, 'Links' => nil, 'LogConfig' => nil, 'Memory' => 0, 'MemorySwap' => 0, 'MemorySwappiness' => 0, 'MemoryReservation' => 0, 'NetworkMode' => 'bridge', 'OomKillDisable' => false, 'OomScoreAdj' => -500, 'Privileged' => false, 'PidMode' => '', 'PortBindings' => {}, 'PublishAllPorts' => false, 'RestartPolicy' => { 'Name' => nil, 'MaximumRetryCount' => 0 }, 'ReadonlyRootfs' => false, 'Runtime' => 'runc', 'SecurityOpt' => nil, 'Sysctls' => {}, 'Ulimits' => nil, 'UsernsMode' => '', 'UTSMode' => '', 'VolumesFrom' => nil, 'VolumeDriver' => nil }, 'NetworkingConfig' => { 'EndpointsConfig' => { 'bridge' => { 'IPAMConfig' => { 'IPv4Address' => nil }, 'Aliases' => [] } } } }
      )
    }
  end

  context 'creates a docker container with healthcheck options' do
    recipe do
      docker_container 'hello_world' do
        tag 'ubuntu:latest'
        health_check(
          'Test' =>
            [
              'string',
            ],
          'Interval' => 0,
          'Timeout' => 0,
          'Retries' => 0,
          'StartPeriod' => 0
        )
        action :create
      end
    end

    it {
      expect { chef_run }.to_not raise_error
      expect(chef_run).to create_docker_container('hello_world').with(
        tag: 'ubuntu:latest',
        create_options: { 'name' => 'hello_world', 'Image' => 'hello_world:ubuntu:latest', 'Labels' => {}, 'Cmd' => nil, 'AttachStderr' => false, 'AttachStdin' => false, 'AttachStdout' => false, 'Domainname' => '', 'Entrypoint' => nil, 'Env' => [], 'ExposedPorts' => {}, 'Hostname' => nil, 'MacAddress' => nil, 'NetworkDisabled' => false, 'OpenStdin' => false, 'StdinOnce' => false, 'Tty' => false, 'User' => '', 'Volumes' => {}, 'WorkingDir' => '', 'HostConfig' => { 'Binds' => nil, 'CapAdd' => nil, 'CapDrop' => nil, 'CgroupParent' => '', 'CpuShares' => 0, 'CpusetCpus' => '', 'Devices' => [], 'Dns' => [], 'DnsSearch' => [], 'ExtraHosts' => nil, 'IpcMode' => '', 'Init' => nil, 'KernelMemory' => 0, 'Links' => nil, 'LogConfig' => nil, 'Memory' => 0, 'MemorySwap' => 0, 'MemorySwappiness' => 0, 'MemoryReservation' => 0, 'NetworkMode' => 'bridge', 'OomKillDisable' => false, 'OomScoreAdj' => -500, 'Privileged' => false, 'PidMode' => '', 'PortBindings' => {}, 'PublishAllPorts' => false, 'RestartPolicy' => { 'Name' => nil, 'MaximumRetryCount' => 0 }, 'ReadonlyRootfs' => false, 'Runtime' => 'runc', 'SecurityOpt' => nil, 'Sysctls' => {}, 'Ulimits' => nil, 'UsernsMode' => '', 'UTSMode' => '', 'VolumesFrom' => nil, 'VolumeDriver' => nil }, 'NetworkingConfig' => { 'EndpointsConfig' => { 'bridge' => { 'IPAMConfig' => { 'IPv4Address' => nil }, 'Aliases' => [] } } }, 'Healthcheck' => { 'Test' => ['string'], 'Interval' => 0, 'Timeout' => 0, 'Retries' => 0, 'StartPeriod' => 0 } }
      )
    }
  end

  context 'creates a docker container with default options for windows' do
    platform 'windows'
    recipe do
      docker_container 'hello_world' do
        tag 'ubuntu:latest'
        action :create
      end
    end

    it {
      expect { chef_run }.to_not raise_error
      expect(chef_run).to create_docker_container('hello_world').with(
        tag: 'ubuntu:latest',
        # Should be missing 'MemorySwappiness'
        create_options: { 'name' => 'hello_world', 'Image' => 'hello_world:ubuntu:latest', 'Labels' => {}, 'Cmd' => nil, 'AttachStderr' => false, 'AttachStdin' => false, 'AttachStdout' => false, 'Domainname' => '', 'Entrypoint' => nil, 'Env' => [], 'ExposedPorts' => {}, 'Hostname' => nil, 'MacAddress' => nil, 'NetworkDisabled' => false, 'OpenStdin' => false, 'StdinOnce' => false, 'Tty' => false, 'User' => '', 'Volumes' => {}, 'WorkingDir' => '', 'HostConfig' => { 'Binds' => nil, 'CapAdd' => nil, 'CapDrop' => nil, 'CgroupParent' => '', 'CpuShares' => 0, 'CpusetCpus' => '', 'Devices' => [], 'Dns' => [], 'DnsSearch' => [], 'ExtraHosts' => nil, 'IpcMode' => '', 'Init' => nil, 'KernelMemory' => 0, 'Links' => nil, 'LogConfig' => nil, 'Memory' => 0, 'MemorySwap' => 0, 'MemoryReservation' => 0, 'NetworkMode' => 'bridge', 'OomKillDisable' => false, 'OomScoreAdj' => -500, 'Privileged' => false, 'PidMode' => '', 'PortBindings' => {}, 'PublishAllPorts' => false, 'RestartPolicy' => { 'Name' => nil, 'MaximumRetryCount' => 0 }, 'ReadonlyRootfs' => false, 'Runtime' => 'runc', 'SecurityOpt' => nil, 'Sysctls' => {}, 'Ulimits' => nil, 'UsernsMode' => '', 'UTSMode' => '', 'VolumesFrom' => nil, 'VolumeDriver' => nil }, 'NetworkingConfig' => { 'EndpointsConfig' => { 'bridge' => { 'IPAMConfig' => { 'IPv4Address' => nil }, 'Aliases' => [] } } } }
      )
    }
  end
end
