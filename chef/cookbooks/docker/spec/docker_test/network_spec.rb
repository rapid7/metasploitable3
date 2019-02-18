require 'spec_helper'

describe 'docker_test::network' do
  cached(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  context 'creates a network with unicode name' do
    it 'creates docker_network_seseme_straße' do
      expect(chef_run).to create_docker_network('seseme_straße')
    end
  end

  context 'creates a network with defaults' do
    it 'creates docker_network_a' do
      expect(chef_run).to create_docker_network('network_a')
    end

    it 'creates echo-base-network_a' do
      expect(chef_run).to run_docker_container('echo-base-network_a')
    end

    it 'creates echo-station-network_a' do
      expect(chef_run).to run_docker_container('echo-station-network_a')
    end
  end

  context 'when testing network deletion' do
    it 'creates network_b with the CLI' do
      expect(chef_run).to run_execute('create network_b').with(
        command: 'docker network create network_b'
      )
    end

    it 'creates /marker_delete_network_b' do
      expect(chef_run).to create_file('/marker_delete_network_b')
    end

    it 'deletes docker_network[network_b]' do
      expect(chef_run).to delete_docker_network('network_b')
    end
  end

  context 'creates a network with subnet and gateway' do
    it 'creates docker_network_c' do
      expect(chef_run).to create_docker_network('network_c').with(
        subnet: '192.168.88.0/24',
        gateway: '192.168.88.1'
      )
    end

    it 'creates echo-base-network_c' do
      expect(chef_run).to run_docker_container('echo-base-network_c')
    end

    it 'creates echo-station-network_c' do
      expect(chef_run).to run_docker_container('echo-station-network_c')
    end
  end

  context 'creates a network with aux_address' do
    it 'creates docker_network_d' do
      expect(chef_run).to create_docker_network('network_d').with(
        subnet: '192.168.89.0/24',
        gateway: '192.168.89.1',
        aux_address: ['a=192.168.89.2', 'b=192.168.89.3']
      )
    end

    it 'creates echo-base-network_d' do
      expect(chef_run).to run_docker_container('echo-base-network_d')
    end

    it 'creates echo-station-network_d' do
      expect(chef_run).to run_docker_container('echo-station-network_d')
    end
  end

  context 'creates a network with overlay driver' do
    it 'creates network_e' do
      expect(chef_run).to create_docker_network('network_e').with(
        driver: 'overlay'
      )
    end
  end

  context 'creates a network with an ip-range' do
    it 'creates docker_network_f' do
      expect(chef_run).to create_docker_network('network_f').with(
        driver: 'bridge',
        subnet: '172.28.0.0/16',
        gateway: '172.28.5.254',
        ip_range: '172.28.5.0/24'
      )
    end

    it 'creates echo-base-network_f' do
      expect(chef_run).to run_docker_container('echo-base-network_f')
    end

    it 'creates echo-station-network_f' do
      expect(chef_run).to run_docker_container('echo-station-network_f')
    end
  end

  context 'create an overlay network with multiple subnets' do
    it 'creates docker_network_g' do
      expect(chef_run).to create_docker_network('network_g').with(
        driver: 'overlay',
        subnet: ['192.168.0.0/16', '192.170.0.0/16'],
        gateway: ['192.168.0.100', '192.170.0.100'],
        ip_range: '192.168.1.0/24',
        aux_address: ['a=192.168.1.5', 'b=192.168.1.6', 'a=192.170.1.5', 'b=192.170.1.6']
      )
    end

    it 'creates echo-base-network_g' do
      expect(chef_run).to run_docker_container('echo-base-network_g')
    end

    it 'creates echo-station-network_g' do
      expect(chef_run).to run_docker_container('echo-station-network_g')
    end
  end

  context 'connect and disconnect a container' do
    it 'creates docker_network_h1' do
      expect(chef_run).to create_docker_network('network_h1')
    end

    it 'creates docker_network_h2' do
      expect(chef_run).to create_docker_network('network_h2')
    end

    it 'creates container1-network_h' do
      expect(chef_run).to run_docker_container('container1-network_h')
    end

    it 'creates /marker/network_h' do
      expect(chef_run).to create_file('/marker_network_h')
    end

    it 'connects container1-network_h with network_h2' do
      expect(chef_run).to connect_docker_network('network_h2 connector').with(
        container: 'container1-network_h'
      )
    end

    it 'disconnects container1-network_h from network_h1' do
      expect(chef_run).to disconnect_docker_network('network_h1 disconnector').with(
        container: 'container1-network_h'
      )
    end
  end

  context 'ipv6 network' do
    it 'creates docker_network_ipv6' do
      expect(chef_run).to create_docker_network('network_ipv6').with(
        enable_ipv6: true,
        subnet: 'fd00:dead:beef::/48'
      )
    end

    it 'creates docker_network_ipv4' do
      expect(chef_run).to create_docker_network('network_ipv4')
    end
  end

  context 'internal network' do
    it 'creates docker_network_internal' do
      expect(chef_run).to create_docker_network('network_internal').with(
        internal: true
      )
    end
  end
end
