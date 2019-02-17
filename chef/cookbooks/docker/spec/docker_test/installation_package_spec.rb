require 'spec_helper'

describe 'docker_test::installation_package' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu',
                             version: '18.04',
                             step_into: ['docker_installation_package']).converge(described_recipe)
  end

  context 'testing default action, default properties' do
    it 'installs docker' do
      expect(chef_run).to create_docker_installation_package('default').with(version: '18.06.0')
    end
  end

  # Coverage of all recent docker versions
  # To ensure test coverage and backwards compatibility
  # With the frequent changes in package naming convention
  # List generated from
  # https://download.docker.com/linux/ubuntu/dists/#{distro}/stable/binary-amd64/Packages

  context 'version strings for Ubuntu 18.04' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu',
                               version: '18.04',
                               step_into: ['docker_installation_package']).converge(described_recipe)
    end

    [
      # Bionic
      { docker_version: '18.03.1', expected: '18.03.1~ce~3-0~ubuntu' },
      { docker_version: '18.06.0', expected: '18.06.0~ce~3-0~ubuntu' },
      { docker_version: '18.06.1', expected: '18.06.1~ce~3-0~ubuntu' },
      { docker_version: '18.09.0', expected: '5:18.09.0~3-0~ubuntu-bionic' },
    ].each do |suite|
      it 'generates the correct version string ubuntu bionic' do
        custom_resource = chef_run.docker_installation_package('default')
        actual = custom_resource.version_string(suite[:docker_version])
        expect(actual).to eq(suite[:expected])
      end
    end
  end

  context 'version strings for Ubuntu 16.04' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu',
                               version: '16.04',
                               step_into: ['docker_installation_package']).converge(described_recipe)
    end

    [
      {  docker_version: '17.03.0', expected: '17.03.0~ce-0~ubuntu-xenial' },
      {  docker_version: '17.03.1', expected: '17.03.1~ce-0~ubuntu-xenial' },
      {  docker_version: '17.03.2', expected: '17.03.2~ce-0~ubuntu-xenial' },
      {  docker_version: '17.03.3', expected: '17.03.3~ce-0~ubuntu-xenial' },
      {  docker_version: '17.06.0', expected: '17.06.0~ce-0~ubuntu' },
      {  docker_version: '17.06.1', expected: '17.06.1~ce-0~ubuntu' },
      {  docker_version: '17.09.0', expected: '17.09.0~ce-0~ubuntu' },
      {  docker_version: '17.09.1', expected: '17.09.1~ce-0~ubuntu' },
      {  docker_version: '17.12.0', expected: '17.12.0~ce-0~ubuntu' },
      {  docker_version: '17.12.1', expected: '17.12.1~ce-0~ubuntu' },
      {  docker_version: '18.03.0', expected: '18.03.0~ce-0~ubuntu' },
      {  docker_version: '18.03.1', expected: '18.03.1~ce-0~ubuntu' },
      {  docker_version: '18.06.0', expected: '18.06.0~ce~3-0~ubuntu' },
      {  docker_version: '18.06.1', expected: '18.06.1~ce~3-0~ubuntu' },
      {  docker_version: '18.09.0', expected: '5:18.09.0~3-0~ubuntu-xenial' },
    ].each do |suite|
      it 'generates the correct version string ubuntu xenial' do
        custom_resource = chef_run.docker_installation_package('default')
        actual = custom_resource.version_string(suite[:docker_version])
        expect(actual).to eq(suite[:expected])
      end
    end
  end

  context 'version strings for Debian 9.5' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'debian',
                               version: '9.5',
                               step_into: ['docker_installation_package']).converge(described_recipe)
    end
    [
      {  docker_version: '17.03.0', expected: '17.03.0~ce-0~debian-stretch' },
      {  docker_version: '17.03.1', expected: '17.03.1~ce-0~debian-stretch' },
      {  docker_version: '17.03.2', expected: '17.03.2~ce-0~debian-stretch' },
      {  docker_version: '17.03.3', expected: '17.03.3~ce-0~debian-stretch' },
      {  docker_version: '17.06.0', expected: '17.06.0~ce-0~debian' },
      {  docker_version: '17.06.1', expected: '17.06.1~ce-0~debian' },
      {  docker_version: '17.09.0', expected: '17.09.0~ce-0~debian' },
      {  docker_version: '17.09.1', expected: '17.09.1~ce-0~debian' },
      {  docker_version: '17.12.0', expected: '17.12.0~ce-0~debian' },
      {  docker_version: '17.12.1', expected: '17.12.1~ce-0~debian' },
      {  docker_version: '18.03.0', expected: '18.03.0~ce-0~debian' },
      {  docker_version: '18.03.1', expected: '18.03.1~ce-0~debian' },
      {  docker_version: '18.06.0', expected: '18.06.0~ce~3-0~debian' },
      {  docker_version: '18.06.1', expected: '18.06.1~ce~3-0~debian' },
      {  docker_version: '18.09.0', expected: '5:18.09.0~3-0~debian-stretch' },
    ].each do |suite|

      it 'generates the correct version string debian stretch' do
        custom_resource = chef_run.docker_installation_package('default')
        actual = custom_resource.version_string(suite[:docker_version])
        expect(actual).to eq(suite[:expected])
      end
    end
  end

  context 'version strings for Centos 7' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos',
                               version: '7',
                               step_into: ['docker_installation_package']).converge(described_recipe)
    end
    # https://download.docker.com/linux/centos/7/x86_64/stable/Packages/
    [
      {  docker_version: '17.03.0', expected: '17.03.0.ce-1.el7.centos' },
      {  docker_version: '17.03.1', expected: '17.03.1.ce-1.el7.centos' },
      {  docker_version: '17.03.2', expected: '17.03.2.ce-1.el7.centos' },
      {  docker_version: '17.03.3', expected: '17.03.3.ce-1.el7' },
      {  docker_version: '17.06.0', expected: '17.06.0.ce-1.el7.centos' },
      {  docker_version: '17.06.1', expected: '17.06.1.ce-1.el7.centos' },
      {  docker_version: '17.09.0', expected: '17.09.0.ce-1.el7.centos' },
      {  docker_version: '17.09.1', expected: '17.09.1.ce-1.el7.centos' },
      {  docker_version: '17.12.0', expected: '17.12.0.ce-1.el7.centos' },
      {  docker_version: '17.12.1', expected: '17.12.1.ce-1.el7.centos' },
      {  docker_version: '18.03.0', expected: '18.03.0.ce-1.el7.centos' },
      {  docker_version: '18.03.1', expected: '18.03.1.ce-1.el7.centos' },
      {  docker_version: '18.06.0', expected: '18.06.0.ce-3.el7' },
      {  docker_version: '18.06.1', expected: '18.06.1.ce-3.el7' },
      {  docker_version: '18.09.0', expected: '18.09.0-3.el7' },
    ].each do |suite|

      it 'generates the correct version string centos 7' do
        custom_resource = chef_run.docker_installation_package('default')
        actual = custom_resource.version_string(suite[:docker_version])
        expect(actual).to eq(suite[:expected])
      end
    end
  end
end
