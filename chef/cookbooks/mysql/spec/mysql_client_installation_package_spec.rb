require 'spec_helper'

describe 'mysql_test::installation_client' do
  let(:installation_client_package_centos_5) { ChefSpec::ServerRunner.new(platform: 'centos', version: '5.11') }
  let(:installation_client_package_centos_6) { ChefSpec::ServerRunner.new(platform: 'centos', version: '6.8') }
  let(:installation_client_package_centos_7) { ChefSpec::ServerRunner.new(platform: 'centos', version: '7.2.1511') }
  let(:installation_client_package_fedora) { ChefSpec::ServerRunner.new(platform: 'fedora', version: '24') }
  let(:installation_client_package_debian_7) { ChefSpec::ServerRunner.new(platform: 'debian', version: '7.11') }
  let(:installation_client_package_debian_8) { ChefSpec::ServerRunner.new(platform: 'debian', version: '8.6') }
  let(:installation_client_package_ubuntu_1204) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '12.04') }
  let(:installation_client_package_ubuntu_1404) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04') }
  let(:installation_client_package_ubuntu_1604) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') }

  context 'using el6' do
    it 'installs mysql_client_installation_package[default] when version is 5.1' do
      installation_client_package_centos_6.node.normal['mysql']['version'] = '5.1'
      installation_client_package_centos_6.converge(described_recipe)
      expect(installation_client_package_centos_6).to install_mysql_client_installation_package('default').with(
        version: '5.1',
        package_name: ['mysql', 'mysql-devel']
      )
    end

    it 'installs mysql_client_installation_package[default] when version is 5.5' do
      installation_client_package_centos_6.node.normal['mysql']['version'] = '5.5'
      installation_client_package_centos_6.converge(described_recipe)
      expect(installation_client_package_centos_6).to install_mysql_client_installation_package('default').with(
        version: '5.5',
        package_name: ['mysql-community-client', 'mysql-community-devel']
      )
    end

    it 'installs mysql_client_installation_package[default] when version is 5.6' do
      installation_client_package_centos_6.node.normal['mysql']['version'] = '5.6'
      installation_client_package_centos_6.converge(described_recipe)
      expect(installation_client_package_centos_6).to install_mysql_client_installation_package('default').with(
        version: '5.6',
        package_name: ['mysql-community-client', 'mysql-community-devel']
      )
    end

    it 'installs mysql_client_installation_package[default] when version is 5.7' do
      installation_client_package_centos_6.node.normal['mysql']['version'] = '5.7'
      installation_client_package_centos_6.converge(described_recipe)
      expect(installation_client_package_centos_6).to install_mysql_client_installation_package('default').with(
        version: '5.7',
        package_name: ['mysql-community-client', 'mysql-community-devel']
      )
    end
  end

  context 'using el7' do
    it 'installs mysql_client_installation_package[default] when version is 5.5' do
      installation_client_package_centos_7.node.normal['mysql']['version'] = '5.5'
      installation_client_package_centos_7.converge(described_recipe)
      expect(installation_client_package_centos_7).to install_mysql_client_installation_package('default').with(
        version: '5.5',
        package_name: ['mysql-community-client', 'mysql-community-devel']
      )
    end

    it 'installs mysql_client_installation_package[default] when version is 5.6' do
      installation_client_package_centos_7.node.normal['mysql']['version'] = '5.6'
      installation_client_package_centos_7.converge(described_recipe)
      expect(installation_client_package_centos_7).to install_mysql_client_installation_package('default').with(
        version: '5.6',
        package_name: ['mysql-community-client', 'mysql-community-devel']
      )
    end

    it 'installs mysql_client_installation_package[default] when version is 5.7' do
      installation_client_package_centos_7.node.normal['mysql']['version'] = '5.7'
      installation_client_package_centos_7.converge(described_recipe)
      expect(installation_client_package_centos_7).to install_mysql_client_installation_package('default').with(
        version: '5.7',
        package_name: ['mysql-community-client', 'mysql-community-devel']
      )
    end
  end

  context 'using fedora 23' do
    it 'installs mysql_client_installation_package[default] when version is 5.7' do
      installation_client_package_fedora.node.normal['mysql']['version'] = '5.7'
      installation_client_package_fedora.converge(described_recipe)
      expect(installation_client_package_fedora).to install_mysql_client_installation_package('default').with(
        version: '5.7',
        package_name: ['mysql-community-client', 'mysql-community-devel']
      )
    end
  end

  context 'using debian 7' do
    it 'installs mysql_client_installation_package[default] when version is 5.5' do
      installation_client_package_debian_7.node.normal['mysql']['version'] = '5.5'
      installation_client_package_debian_7.converge(described_recipe)
      expect(installation_client_package_debian_7).to install_mysql_client_installation_package('default').with(
        version: '5.5',
        package_name: ['mysql-client-5.5', 'libmysqlclient-dev']
      )
    end
  end

  context 'using debian 8' do
    it 'installs mysql_client_installation_package[default] when version is 5.5' do
      installation_client_package_debian_8.node.normal['mysql']['version'] = '5.5'
      installation_client_package_debian_8.converge(described_recipe)
      expect(installation_client_package_debian_8).to install_mysql_client_installation_package('default').with(
        version: '5.5',
        package_name: ['mysql-client-5.5', 'libmysqlclient-dev']
      )
    end
  end

  context 'using ubuntu 12.04' do
    it 'installs mysql_client_installation_package[default] when version is 5.5' do
      installation_client_package_ubuntu_1204.node.normal['mysql']['version'] = '5.5'
      installation_client_package_ubuntu_1204.converge(described_recipe)
      expect(installation_client_package_ubuntu_1204).to install_mysql_client_installation_package('default').with(
        version: '5.5',
        package_name: ['mysql-client-5.5', 'libmysqlclient-dev']
      )
    end
  end

  context 'using ubuntu 14.04' do
    it 'installs mysql_client_installation_package[default] when version is 5.5' do
      installation_client_package_ubuntu_1404.node.normal['mysql']['version'] = '5.5'
      installation_client_package_ubuntu_1404.converge(described_recipe)
      expect(installation_client_package_ubuntu_1404).to install_mysql_client_installation_package('default').with(
        version: '5.5',
        package_name: ['mysql-client-5.5', 'libmysqlclient-dev']
      )
    end
  end

  context 'using ubuntu 14.04' do
    it 'installs mysql_client_installation_package[default] when version is 5.6' do
      installation_client_package_ubuntu_1404.node.normal['mysql']['version'] = '5.6'
      installation_client_package_ubuntu_1404.converge(described_recipe)
      expect(installation_client_package_ubuntu_1404).to install_mysql_client_installation_package('default').with(
        version: '5.6',
        package_name: ['mysql-client-5.6', 'libmysqlclient-dev']
      )
    end
  end

  context 'using ubuntu 16.04' do
    it 'installs mysql_client_installation_package[default] when version is 5.7' do
      installation_client_package_ubuntu_1604.node.normal['mysql']['version'] = '5.7'
      installation_client_package_ubuntu_1604.converge(described_recipe)
      expect(installation_client_package_ubuntu_1604).to install_mysql_client_installation_package('default').with(
        version: '5.7',
        package_name: ['mysql-client-5.7', 'libmysqlclient-dev']
      )
    end
  end
end
