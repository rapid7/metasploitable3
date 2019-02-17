require 'spec_helper'

describe 'docker_test::image_prune' do
  context 'it steps over the provider' do
    cached(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '18.04').converge(described_recipe) }

    context 'testing default action, default properties' do
      it 'prunes docker_image[hello-world]' do
        expect(chef_run).to prune_docker_image_prune('hello-world').with(
          dangling: true
        )
      end

      it 'prunes docker_image[hello-world]' do
        expect(chef_run).to prune_docker_image_prune('prune-old-images').with(
          dangling: true,
          prune_until: '1h30m',
          with_label: 'com.example.vendor=ACME',
          without_label: 'no_prune'
        )
      end
    end
  end
end
