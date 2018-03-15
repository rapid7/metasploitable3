module DockerCookbook
  module DockerHelpers
    module InstallationPackage
      def el6?
        return true if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 6
        false
      end

      def el7?
        return true if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 7
        false
      end

      def fedora?
        return true if node['platform'] == 'fedora'
        false
      end

      def wheezy?
        return true if node['platform'] == 'debian' && node['platform_version'].to_i == 7
        false
      end

      def jesse?
        return true if node['platform'] == 'debian' && node['platform_version'].to_i == 8
        false
      end

      def precise?
        return true if node['platform'] == 'ubuntu' && node['platform_version'] == '12.04'
        false
      end

      def trusty?
        return true if node['platform'] == 'ubuntu' && node['platform_version'] == '14.04'
        return true if node['platform'] == 'linuxmint' && node['platform_version'] =~ /^17\.[0-9]$/
        false
      end

      def vivid?
        return true if node['platform'] == 'ubuntu' && node['platform_version'] == '15.04'
        false
      end

      def wily?
        return true if node['platform'] == 'ubuntu' && node['platform_version'] == '15.10'
        false
      end

      def xenial?
        return true if node['platform'] == 'ubuntu' && node['platform_version'] == '16.04'
        false
      end

      def amazon?
        return true if node['platform'] == 'amazon'
        false
      end

      # https://github.com/chef/chef/issues/4103
      def version_string(v)
        ubuntu_prefix = if Gem::Version.new(v) > Gem::Version.new('1.12.3')
                          'ubuntu-'
                        else
                          ''
                        end

        debian_prefix = if Gem::Version.new(v) > Gem::Version.new('1.12.3')
                          'debian-'
                        else
                          ''
                        end

        return "#{v}-1.el6" if el6?
        return "#{v}-1.el7.centos" if el7?
        return "#{v}-1.17.amzn1" if amazon?
        return "#{v}-1.fc#{node['platform_version'].to_i}" if fedora?
        return "#{v}-0~#{debian_prefix}wheezy" if wheezy?
        return "#{v}-0~#{debian_prefix}jessie" if jesse?
        return "#{v}-0~#{ubuntu_prefix}precise" if precise?
        return "#{v}-0~#{ubuntu_prefix}trusty" if trusty?
        return "#{v}-0~#{ubuntu_prefix}vivid" if vivid?
        return "#{v}-0~#{ubuntu_prefix}wily" if wily?
        return "#{v}-0~#{ubuntu_prefix}xenial" if xenial?
        v
      end

      def default_docker_version
        return '1.7.1' if el6?
        return '1.9.1' if vivid?
        return '1.12.6' if amazon?
        '1.13.1'
      end

      def default_package_name
        return 'docker' if amazon?
        'docker-engine'
      end

      def docker_bin
        '/usr/bin/docker'
      end
    end
  end
end
