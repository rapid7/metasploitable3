require 'spec_helper'

describe 'docker_test::plugin' do
  cached(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  let(:sshfs_caps) do
    [
      {
        'Name' => 'network',
        'Value' => ['host'],
      },
      {
        'Name' => 'mount',
        'Value' => ['/var/lib/docker/plugins/'],
      },
      {
        'Name' => 'mount',
        'Value' => [''],
      },
      {
        'Name' => 'device',
        'Value' => ['/dev/fuse'],
      },
      {
        'Name' => 'capabilities',
        'Value' => ['CAP_SYS_ADMIN'],
      },
    ]
  end

  context 'testing default action, default properties, but with privilege grant' do
    it 'installs vieux/sshfs' do
      expect(chef_run).to install_docker_plugin('vieux/sshfs').with(
        api_retries: 3,
        grant_privileges: sshfs_caps,
        options: {},
        remote_tag: 'latest'
      )
    end
  end

  context 'reconfigure existing plugin' do
    it 'enables debug on vieux/sshfs' do
      expect(chef_run).to update_docker_plugin('configure vieux/sshfs').with(
        api_retries: 3,
        grant_privileges: [],
        options: {
          'DEBUG' => '1',
        },
        local_alias: 'vieux/sshfs',
        remote_tag: 'latest'
      )
    end
  end

  context 'testing the remove action' do
    it 'removes vieux/sshfs' do
      expect(chef_run).to remove_docker_plugin('remove vieux/sshfs').with(
        api_retries: 3,
        grant_privileges: [],
        options: {},
        local_alias: 'vieux/sshfs',
        remote_tag: 'latest'
      )
    end
  end

  context 'testing configure and install at the same time' do
    it 'installs wetopi/rbd' do
      expect(chef_run).to install_docker_plugin('rbd').with(
        remote: 'wetopi/rbd',
        remote_tag: '1.0.1',
        grant_privileges: true,
        options: {
          'LOG_LEVEL' => '4',
        }
      )
    end

    it 'removes wetopi/rbd again' do
      expect(chef_run).to remove_docker_plugin('remove rbd').with(
        local_alias: 'rbd'
      )
    end
  end

  context 'install is idempotent' do
    it 'installs vieux/sshfs two times' do
      expect(chef_run).to install_docker_plugin('sshfs 2.1').with(
        remote: 'vieux/sshfs',
        remote_tag: 'latest',
        local_alias: 'sshfs',
        grant_privileges: true
      )

      expect(chef_run).to install_docker_plugin('sshfs 2.2').with(
        remote: 'vieux/sshfs',
        remote_tag: 'latest',
        local_alias: 'sshfs',
        grant_privileges: true
      )
    end
  end

  context 'test :enable / :disable action' do
    it 'enables sshfs' do
      expect(chef_run).to enable_docker_plugin('enable sshfs').with(
        local_alias: 'sshfs'
      )
    end

    it 'disables sshfs' do
      expect(chef_run).to disable_docker_plugin('disable sshfs').with(
        local_alias: 'sshfs'
      )
    end
  end
end
