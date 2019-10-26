require 'spec_helper'

describe 'apt::cacher-client' do
  context 'no server' do
    let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

    before do
      stub_command('grep Acquire::http::Proxy /etc/apt/apt.conf').and_return(false)
    end

    it 'does not create 01proxy file' do
      expect(chef_run).not_to create_file('/etc/apt/apt.conf.d/01proxy')
    end
  end

  context 'server provided' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
      runner.node.normal['apt']['cacher_client']['cacher_server'] = {
        host: 'localhost',
        port: 9876,
        proxy_ssl: true,
      }
      runner.converge('apt::cacher-client')
    end

    before do
      stub_command('grep Acquire::http::Proxy /etc/apt/apt.conf').and_return(false)
    end

    it 'creates 01proxy file' do
      expect(chef_run).to render_file('/etc/apt/apt.conf.d/01proxy').with_content('Acquire::http::Proxy "http://localhost:9876";')
    end
  end
end
