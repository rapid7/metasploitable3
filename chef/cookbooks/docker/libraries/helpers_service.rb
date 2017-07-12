# Constants
IPV6_ADDR ||= /(
([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|
([0-9a-fA-F]{1,4}:){1,7}:|
([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|
([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|
([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|
([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|
([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|
[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|
:((:[0-9a-fA-F]{1,4}){1,7}|:)|
fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|
::(ffff(:0{1,4}){0,1}:){0,1}
((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}
(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|
([0-9a-fA-F]{1,4}:){1,4}:
((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}
(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])
)/

IPV4_ADDR ||= /((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])/

IPV6_CIDR ||= /s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]d|1dd|[1-9]?d)(.(25[0-5]|2[0-4]d|1dd|[1-9]?d)){3}))|:)))(%.+)?s*/

IPV4_CIDR ||= %r{(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/([0-9]|[1-2][0-9]|3[0-2]))}

module DockerCookbook
  module DockerHelpers
    module Service
      def docker_bin
        '/usr/bin/docker'
      end

      def dockerd_bin
        return '/usr/bin/docker' if Gem::Version.new(docker_major_version) < Gem::Version.new('1.12')
        '/usr/bin/dockerd'
      end

      def dockerd_bin_link
        "/usr/bin/dockerd-#{name}"
      end

      def docker_name
        return 'docker' if name == 'default'
        "docker-#{name}"
      end

      def installed_docker_version
        o = shell_out("#{docker_bin} --version")
        o.stdout.split[2].chomp(',')
      end

      def connect_host
        return nil unless host
        sorted = coerce_host(host).sort do |a, b|
          c_a = 1 if a =~ /^unix:/
          c_a = 2 if a =~ /^fd:/
          c_a = 3 if a =~ %r{^tcp://127.0.0.1:}
          c_a = 4 if a =~ %r{^tcp://(192\.168|10\.|172\.1[6789]\.|172\.2[0-9]\.|172\.3[01]\.).*:}
          c_a = 5 if a =~ %r{^tcp://0.0.0.0:}
          c_a = 6 unless c_a
          c_b = 1 if b =~ /^unix:/
          c_b = 2 if b =~ /^fd:/
          c_b = 3 if b =~ %r{^tcp://127.0.0.1:}
          c_b = 4 if b =~ %r{^tcp://(192\.168|10\.|172\.1[6789]\.|172\.2[0-9]\.|172\.3[01]\.).*:}
          c_b = 5 if b =~ %r{^tcp://0.0.0.0:}
          c_b = 6 unless c_b
          c_a <=> c_b
        end
        if sorted.first =~ %r{^tcp://0.0.0.0:}
          r = sorted.first.match(%r{(?<proto>.*)://(?<socket>[^:]+):?(?<port>\d+)?})
          return "tcp://127.0.0.1:#{r['port']}"
        end
        sorted.first
      end

      def connect_socket
        return "/var/run/#{docker_name}.sock" unless host
        sorted = coerce_host(host).sort do |a, b|
          c_a = 1 if a =~ /^unix:/
          c_a = 2 if a =~ /^fd:/
          c_a = 3 unless c_a
          c_b = 1 if b =~ /^unix:/
          c_b = 2 if b =~ /^fd:/
          c_b = 3 unless c_b
          c_a <=> c_b
        end
        sorted.first
      end

      def coerce_host(v)
        v = v.split if v.is_a?(String)
        Array(v).each_with_object([]) do |s, r|
          if s.match(/^unix:/) || s.match(/^tcp:/) || s.match(/^fd:/)
            r << s
          else
            Chef::Log.info("WARNING: docker_service host property #{s} not valid")
          end
        end
      end

      def coerce_daemon_labels(v)
        Array(v).each_with_object([]) do |label, a|
          if label =~ /:/
            parts = label.split(':')
            a << "#{parts[0]}=\"#{parts[1]}\""
          elsif label =~ /=/
            parts = label.split('=')
            a << "#{parts[0]}=#{parts[1]}"
          else
            Chef::Log.info("WARNING: docker_service label #{label} not valid")
          end
        end
      end

      def coerce_insecure_registry(v)
        case v
        when Array, nil
          v
        else
          Array(v)
        end
      end

      def docker_major_version
        ray = installed_docker_version.split('.')
        ray.pop
        ray.push.join('.')
      end

      def docker_daemon_arg
        if Gem::Version.new(docker_major_version) < Gem::Version.new('1.8')
          '-d'
        elsif Gem::Version.new(docker_major_version) < Gem::Version.new('1.12')
          'daemon'
        else
          ''
        end
      end

      def docker_daemon_cmd
        [dockerd_bin, docker_daemon_arg, docker_daemon_opts].join(' ')
      end

      def docker_cmd
        [docker_bin, docker_opts].join(' ')
      end

      def docker_opts
        opts = []
        opts << "--host=#{connect_host}" if connect_host
        if connect_host =~ /^tcp:/
          opts << "--tls=#{tls}" unless tls.nil?
          opts << "--tlsverify=#{tls_verify}" unless tls_verify.nil?
          opts << "--tlscacert=#{tls_ca_cert}" if tls_ca_cert
          opts << "--tlscert=#{tls_client_cert}" if tls_client_cert
          opts << "--tlskey=#{tls_client_key}" if tls_client_key
        end
        opts
      end

      def systemd_args
        opts = ''
        systemd_opts.each { |systemd_opt| opts << "#{systemd_opt}\n" } if systemd_opts
        opts
      end

      def docker_daemon_opts
        opts = []
        opts << "--api-cors-header=#{api_cors_header}" if api_cors_header
        opts << "--bridge=#{bridge}" if bridge
        opts << "--bip=#{bip}" if bip
        opts << '--debug' if debug
        opts << "--cluster-advertise=#{cluster_advertise}" if cluster_advertise
        opts << "--cluster-store=#{cluster_store}" if cluster_store
        cluster_store_opts.each { |store_opt| opts << "--cluster-store-opt=#{store_opt}" } if cluster_store_opts
        default_ulimit.each { |u| opts << "--default-ulimit=#{u}" } if default_ulimit
        dns.each { |dns| opts << "--dns=#{dns}" } if dns
        dns_search.each { |dns| opts << "--dns-search=#{dns}" } if dns_search
        opts << "--exec-driver=#{exec_driver}" if exec_driver
        exec_opts.each { |exec_opt| opts << "--exec-opt=#{exec_opt}" } if exec_opts
        opts << "--fixed-cidr=#{fixed_cidr}" if fixed_cidr
        opts << "--fixed-cidr-v6=#{fixed_cidr_v6}" if fixed_cidr_v6
        opts << "--group=#{group}" if group
        opts << "--graph=#{graph}" if graph
        host.each { |h| opts << "-H #{h}" } if host
        opts << "--icc=#{icc}" unless icc.nil?
        insecure_registry.each { |i| opts << "--insecure-registry=#{i}" } if insecure_registry
        opts << "--ip=#{ip}" if ip
        opts << "--ip-forward=#{ip_forward}" unless ip_forward.nil?
        opts << "--ip-masq=#{ip_masq}" unless ip_masq.nil?
        opts << "--iptables=#{iptables}" unless iptables.nil?
        opts << "--ipv6=#{ipv6}" unless ipv6.nil?
        opts << "--log-level=#{log_level}" if log_level
        labels.each { |l| opts << "--label=#{l}" } if labels
        opts << "--log-driver=#{log_driver}" if log_driver
        log_opts.each { |log_opt| opts << "--log-opt #{log_opt}" } if log_opts
        opts << "--mtu=#{mtu}" if mtu
        opts << "--pidfile=#{pidfile}" if pidfile
        opts << "--registry-mirror=#{registry_mirror}" if registry_mirror
        storage_driver.each { |s| opts << "--storage-driver=#{s}" } if storage_driver
        opts << "--selinux-enabled=#{selinux_enabled}" unless selinux_enabled.nil?
        storage_opts.each { |storage_opt| opts << "--storage-opt=#{storage_opt}" } if storage_opts
        opts << "--tls=#{tls}" unless tls.nil?
        opts << "--tlsverify=#{tls_verify}" unless tls_verify.nil?
        opts << "--tlscacert=#{tls_ca_cert}" if tls_ca_cert
        opts << "--tlscert=#{tls_server_cert}" if tls_server_cert
        opts << "--tlskey=#{tls_server_key}" if tls_server_key
        opts << "--userland-proxy=#{userland_proxy}" unless userland_proxy.nil?
        opts << "--disable-legacy-registry=#{disable_legacy_registry}" unless disable_legacy_registry.nil?
        opts << "--userns-remap=#{userns_remap}" if userns_remap
        opts << misc_opts if misc_opts
        opts
      end

      def docker_running?
        o = shell_out("#{docker_cmd} ps | head -n 1 | grep ^CONTAINER")
        return true if o.stdout =~ /CONTAINER/
        false
      end
    end
  end
end
