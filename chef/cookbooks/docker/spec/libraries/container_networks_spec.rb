require 'spec_helper'
require 'docker'
require_relative '../../libraries/docker_base'
require_relative '../../libraries/docker_container'

describe DockerCookbook::DockerContainer do
  let(:resource) { DockerCookbook::DockerContainer.new('hello_world') }

  it 'has a default action of [:run]' do
    expect(resource.action).to eql([:run])
  end

  describe 'gets ip_address_from_container_networks' do
    let(:options) { { 'id' => rand(10_000).to_s } }
    subject do
      Docker::Container.send(:new, Docker.connection, options)
    end
    # https://docs.docker.com/engine/api/version-history/#v121-api-changes
    context 'when docker API < 1.21' do
      let(:ip_address) { '10.0.0.1' }
      let(:options) do
        {
          'id' => rand(10_000).to_s,
          'IPAddress' => ip_address,
        }
      end
      it 'gets ip_address as nil' do
        actual = resource.ip_address_from_container_networks(subject)
        expect { resource.ip_address_from_container_networks(subject) }.not_to raise_error
        expect(actual).to eq(nil)
      end
    end
    context 'when docker API > 1.21' do
      let(:ip_address) { '10.0.0.1' }
      let(:options) do
        {
          'id' => rand(10_000).to_s,
          'NetworkSettings' => {
            'Networks' => {
              'bridge' => {
                'IPAMConfig' => {
                  'IPv4Address' => ip_address,
                },
              },
            },
          },
        }
      end
      it 'gets ip_address' do
        actual = resource.ip_address_from_container_networks(subject)
        expect(actual).to eq(ip_address)
      end
    end
  end
end
