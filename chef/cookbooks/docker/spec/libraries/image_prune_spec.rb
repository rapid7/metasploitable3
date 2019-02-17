require 'spec_helper'
require_relative '../../libraries/docker_base'
require_relative '../../libraries/docker_image_prune'

describe DockerCookbook::DockerImagePrune do
  let(:resource) { DockerCookbook::DockerImagePrune.new('rspec') }

  it 'has a default action of [:prune]' do
    expect(resource.action).to eql([:prune])
  end

  it 'generates filter json' do
    # Arrange
    expected = '{"filters":["dangling=true","until=1h30m","label=com.example.vendor=ACME","label!=no_prune"]}'
    resource.dangling = true
    resource.prune_until = '1h30m'
    resource.with_label = 'com.example.vendor=ACME'
    resource.without_label = 'no_prune'
    resource.action :prune

    # Act
    actual = resource.generate_json(resource)

    # Assert
    expect(actual).to eq(expected)
  end
end
