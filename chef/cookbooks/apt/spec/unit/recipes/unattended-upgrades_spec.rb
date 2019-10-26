require 'spec_helper'

describe 'apt::unattended-upgrades' do
  context 'default' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge('apt::unattended-upgrades')
    end

    it 'installs unattended-upgrades' do
      # expect(chef_run).to install_package 'unattended-upgrades'
    end

    it 'creates 20auto-upgrades file' do
      # expect(chef_run).to render_file('/etc/apt/apt.conf.d/20auto-upgrades').with_content()
      # expect(chef_run).to create_file_with_content('/etc/apt/apt.conf.d/20auto-upgrades', 'APT::Periodic::Update-Package-Lists "1";')
      # expect(chef_run).to create_file_with_content('/etc/apt/apt.conf.d/20auto-upgrades', 'APT::Periodic::Unattended-Upgrade "0";')
    end

    it 'creates 50unattended-upgrades file' do
      # expect(chef_run).to render_file('/etc/apt/apt.conf.d/50auto-upgrades').with_content()
    end
  end
end
