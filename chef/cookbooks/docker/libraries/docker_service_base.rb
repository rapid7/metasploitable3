module DockerCookbook
  class DockerServiceBase < DockerBase
    ################
    # Helper Methods
    ################
    require 'docker'
    require_relative 'helpers_service'
    include DockerHelpers::Service

    #####################
    # resource properties
    #####################

    resource_name :docker_service_base

    # register with the resource resolution system
    provides :docker_service_manager

    # daemon management
    property :instance, String, name_property: true, required: true, desired_state: false
    property :auto_restart, Boolean, default: false
    property :api_cors_header, [String, nil]
    property :bridge, [String, nil]
    property :bip, [IPV4_ADDR, IPV4_CIDR, IPV6_ADDR, IPV6_CIDR, nil]
    property :cluster_store, [String, nil]
    property :cluster_advertise, [String, nil]
    property :cluster_store_opts, ArrayType
    property :debug, [Boolean, nil]
    property :daemon, Boolean, default: true
    property :dns, ArrayType
    property :dns_search, [Array, nil]
    property :exec_driver, ['native', 'lxc', nil]
    property :exec_opts, ArrayType
    property :fixed_cidr, [String, nil]
    property :fixed_cidr_v6, [String, nil]
    property :group, [String, nil]
    property :graph, [String, nil]
    property :host, [String, Array], coerce: proc { |v| coerce_host(v) }
    property :icc, [Boolean, nil]
    property :insecure_registry, [Array, String, nil], coerce: proc { |v| coerce_insecure_registry(v) }
    property :ip, [IPV4_ADDR, IPV6_ADDR, nil]
    property :ip_forward, [Boolean, nil]
    property :ipv4_forward, Boolean, default: true
    property :ipv6_forward, Boolean, default: true
    property :ip_masq, [Boolean, nil]
    property :iptables, [Boolean, nil]
    property :ipv6, [Boolean, nil]
    property :log_level, [:debug, :info, :warn, :error, :fatal, nil]
    property :labels, [String, Array], coerce: proc { |v| coerce_daemon_labels(v) }, desired_state: false
    property :log_driver, %w( json-file syslog journald gelf fluentd awslogs splunk none )
    property :log_opts, ArrayType
    property :mount_flags, String, default: 'slave'
    property :mtu, [String, nil]
    property :pidfile, String, default: lazy { "/var/run/#{docker_name}.pid" }
    property :registry_mirror, [String, nil]
    property :storage_driver, ArrayType
    property :selinux_enabled, [Boolean, nil]
    property :storage_opts, ArrayType
    property :default_ulimit, ArrayType
    property :userland_proxy, [Boolean, nil]
    property :disable_legacy_registry, [Boolean, nil]
    property :userns_remap, [String, nil]

    # These are options specific to systemd configuration such as
    # LimitNOFILE or TasksMax that you may wannt to use to customize
    # the environment in which Docker runs.
    property :systemd_opts, ArrayType

    # These are unvalidated daemon arguments passed in as a string.
    property :misc_opts, [String, nil]

    # environment variables to set before running daemon
    property :http_proxy, [String, nil]
    property :https_proxy, [String, nil]
    property :no_proxy, [String, nil]
    property :tmpdir, [String, nil]

    # logging
    property :logfile, String, default: '/var/log/docker.log'

    # docker-wait-ready timeout
    property :service_timeout, Integer, default: 20

    allowed_actions :start, :stop, :restart

    alias label labels
    alias tlscacert tls_ca_cert
    alias tlscert tls_server_cert
    alias tlskey tls_server_key
    alias tlsverify tls_verify
    alias run_group group

    declare_action_class.class_eval do
      def libexec_dir
        return '/usr/libexec/docker' if node['platform_family'] == 'rhel'
        '/usr/lib/docker'
      end

      def create_docker_wait_ready
        directory libexec_dir do
          owner 'root'
          group 'root'
          mode '0755'
          action :create
        end

        template "#{libexec_dir}/#{docker_name}-wait-ready" do
          source 'default/docker-wait-ready.erb'
          owner 'root'
          group 'root'
          mode '0755'
          variables(
            docker_cmd: docker_cmd,
            libexec_dir: libexec_dir,
            service_timeout: service_timeout
          )
          cookbook 'docker'
          action :create
        end
      end
    end
  end
end
