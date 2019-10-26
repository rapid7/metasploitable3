require 'spec_helper'

describe 'apt::cacher-ng' do
  context 'server' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.normal['apt']['cacher_port'] = '9876'
      runner.converge('apt::cacher-ng')
    end

    # it 'installs apt-cacher-ng' do
    #   expect(chef_run).to install_package('apt-cacher-ng')
    # end

    # it 'creates acng.conf file' do
    #   expect(chef_run).to create_file('/etc/apt-cacher-ng/acng.conf')
    # end

    # it 'enables and starts apt-cacher-ng' do
    #   expect(chef_run).to set_service_to_start_on_boot 'apt-cacher-ng'
    #   expect(chef_run).to start_service 'apt-cacher-ng'
    # end
  end
end
