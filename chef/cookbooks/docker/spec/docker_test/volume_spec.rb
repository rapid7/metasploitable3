require 'spec_helper'

describe 'docker_test::volume' do
  cached(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'pull_if_missing docker_image[alpine]' do
    expect(chef_run).to pull_if_missing_docker_image('alpine').with(
      tag: '3.1'
    )
  end

  context 'testing remove action' do
    it 'executes docker creates volume --name remove_me' do
      expect(chef_run).to run_execute('docker volume create --name remove_me')
    end

    it 'creates file /marker_remove_me' do
      expect(chef_run).to create_file('/marker_remove_me')
    end

    it 'removes docker_volume[remove_me]' do
      expect(chef_run).to remove_docker_volume('remove_me')
    end
  end

  context 'testing create action' do
    it 'creates volume hello' do
      expect(chef_run).to create_docker_volume('hello')
    end

    it 'creates volume hello again' do
      expect(chef_run).to create_docker_volume('hello again').with(
        volume_name: 'hello_again'
      )
    end

    context 'testing create action' do
      it 'runs file_writer' do
        expect(chef_run).to run_if_missing_docker_container('file_writer')
      end

      it 'runs file_writer' do
        expect(chef_run).to run_if_missing_docker_container('file_reader')
      end
    end
  end
end
