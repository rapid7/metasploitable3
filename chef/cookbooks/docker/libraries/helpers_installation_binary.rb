module DockerCookbook
  module DockerHelpers
    module InstallationBinary
      def docker_bin
        '/usr/bin/docker'
      end

      def docker_kernel
        node['kernel']['name']
      end

      def docker_arch
        node['kernel']['machine']
      end

      def default_source
        "https://get.docker.com/builds/#{docker_kernel}/#{docker_arch}/docker-#{version}"
      end

      def default_checksum
        case docker_kernel
        when 'Darwin'
          case version
          when '1.6.0' then '9e960e925561b4ec2b81f52b6151cd129739c1f4fba91ce94bdc0333d7d98c38'
          when '1.6.2' then 'f29b8b2185c291bd276f7cdac45a674f904e964426d5b969fda7b8ef6b8ab557'
          when '1.7.0' then '1c8ee59249fdde401afebc9a079cb75d7674f03d2491789fb45c88020a8c5783'
          when '1.7.1' then 'b8209b4382d0b4292c756dd055c12e5efacec2055d5900ac91efc8e81d317cf9'
          when '1.8.1' then '0f5db35127cf14b57614ad7513296be600ddaa79182d8d118d095cb90c721e3a'
          when '1.8.2' then 'cef593612752e5a50bd075931956075a534b293b7002892072397c3093fe11a6'
          when '1.8.3' then 'b5a63a0e6fb393de8c3543c83433224796c7545901963ff3e3e9a41b1430c9cd'
          when '1.9.0' then '91a8701e41a479def5371a333657c58c36478602e1f5eb1835457a3880232a2e'
          when '1.9.1' then '8750ccc2098ec94ef7db110e0016ab02cfa47a1a76f0deb3faa50335b5ec0df9'
          when '1.10.0' then 'f8dc0c7ef2a7efbe0e062017822066e55a40c752b9e92a636359f59ef562d79f'
          when '1.10.1' then 'de4057057acd259ec38b5244a40d806993e2ca219e9869ace133fad0e09cedf2'
          when '1.10.2' then '29249598587ad8f8597235bbeb11a11888fffb977b8089ea80b5ac5267ba9f2e'
          end
        when 'Linux'
          case version
          when '1.6.0' then '526fbd15dc6bcf2f24f99959d998d080136e290bbb017624a5a3821b63916ae8'
          when '1.6.2' then 'e131b2d78d9f9e51b0e5ca8df632ac0a1d48bcba92036d0c839e371d6cf960ec'
          when '1.7.1' then '4d535a62882f2123fb9545a5d140a6a2ccc7bfc7a3c0ec5361d33e498e4876d5'
          when '1.8.1' then '843f90f5001e87d639df82441342e6d4c53886c65f72a5cc4765a7ba3ad4fc57'
          when '1.8.2' then '97a3f5924b0b831a310efa8bf0a4c91956cd6387c4a8667d27e2b2dd3da67e4d'
          when '1.8.3' then 'f024bc65c45a3778cf07213d26016075e8172de8f6e4b5702bedde06c241650f'
          when '1.9.0' then '5d46455aac507e231fd2a558459779f1994f7151d6cb027efabfa36f568cf017'
          when '1.9.1' then '52286a92999f003e1129422e78be3e1049f963be1888afc3c9a99d5a9af04666'
          when '1.10.0' then 'a66b20423b7d849aa8ef448b98b41d18c45a30bf3fe952cc2ba4760600b18087'
          when '1.10.1' then 'de4057057acd259ec38b5244a40d806993e2ca219e9869ace133fad0e09cedf2'
          when '1.10.2' then '3fcac4f30e1c1a346c52ba33104175ae4ccbd9b9dbb947f56a0a32c9e401b768'
          end
        end
      end

      def default_version
        if node['platform'] == 'amazon' ||
           node['platform'] == 'ubuntu' && node['platform_version'].to_f < 15.04 ||
           node['platform_family'] == 'rhel' && node['platform_version'].to_i < 7 ||
           node['platform_family'] == 'debian' && node['platform_version'].to_i <= 7
          '1.6.2'
        else
          '1.10.2'
        end
      end
    end
  end
end
