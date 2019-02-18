module DockerCookbook
  class DockerServiceBase < DockerBase
    ################
    # Helper Methods
    ################
    require_relative 'helpers_service'
    include DockerHelpers::Service

    #####################
    # resource properties
    #####################

    resource_name :docker_service_base

    # register with the resource resolution system
    provides :docker_service_manager

    # Environment variables to docker service
    property :env_vars, Hash

    # daemon management
    property :instance, String, name_property: true, desired_state: false
    property :auto_restart, [TrueClass, FalseClass], default: false
    property :api_cors_header, String
    property :bridge, String
    property :bip, [IPV4_ADDR, IPV4_CIDR, IPV6_ADDR, IPV6_CIDR, nil]
    property :cluster_store, String
    property :cluster_advertise, String
    property :cluster_store_opts, [String, Array], coerce: proc { |v| v.nil? ? nil : Array(v) }
    property :daemon, [TrueClass, FalseClass], default: true
    property :data_root, String
    property :debug, [TrueClass, FalseClass], default: false
    property :dns, [String, Array], coerce: proc { |v| v.nil? ? nil : Array(v) }
    property :dns_search, Array
    property :exec_driver, ['native', 'lxc', nil]
    property :exec_opts, [String, Array], coerce: proc { |v| v.nil? ? nil : Array(v) }
    property :fixed_cidr, String
    property :fixed_cidr_v6, String
    property :group, String, default: 'docker'
    property :host, [String, Array], coerce: proc { |v| coerce_host(v) }, desired_state: false
    property :icc, [TrueClass, FalseClass]
    property :insecure_registry, [Array, String, nil], coerce: proc { |v| coerce_insecure_registry(v) }
    property :ip, [IPV4_ADDR, IPV6_ADDR, nil]
    property :ip_forward, [TrueClass, FalseClass]
    property :ipv4_forward, [TrueClass, FalseClass], default: true
    property :ipv6_forward, [TrueClass, FalseClass], default: true
    property :ip_masq, [TrueClass, FalseClass]
    property :iptables, [TrueClass, FalseClass]
    property :ipv6, [TrueClass, FalseClass]
    property :default_ip_address_pool, String
    property :log_level, %w(debug info warn error fatal)
    property :labels, [String, Array], coerce: proc { |v| coerce_daemon_labels(v) }, desired_state: false
    property :log_driver, %w(json-file syslog journald gelf fluentd awslogs splunk none)
    property :log_opts, [String, Array], coerce: proc { |v| v.nil? ? nil : Array(v) }
    property :mount_flags, String
    property :mtu, String
    property :pidfile, String, default: lazy { "/var/run/#{docker_name}.pid" }
    property :registry_mirror, String
    property :storage_driver, [String, Array], coerce: proc { |v| v.nil? ? nil : Array(v) }
    property :selinux_enabled, [TrueClass, FalseClass]
    property :storage_opts, Array
    property :default_ulimit, [String, Array], coerce: proc { |v| v.nil? ? nil : Array(v) }
    property :userland_proxy, [TrueClass, FalseClass]
    property :disable_legacy_registry, [TrueClass, FalseClass]
    property :userns_remap, String

    # These are options specific to systemd configuration such as
    # LimitNOFILE or TasksMax that you may wannt to use to customize
    # the environment in which Docker runs.
    property :systemd_opts, [String, Array], coerce: proc { |v| v.nil? ? nil : Array(v) }
    property :systemd_socket_opts, [String, Array], coerce: proc { |v| v.nil? ? nil : Array(v) }

    # These are unvalidated daemon arguments passed in as a string.
    property :misc_opts, String

    # environment variables to set before running daemon
    property :http_proxy, String
    property :https_proxy, String
    property :no_proxy, String
    property :tmpdir, String

    # logging
    property :logfile, String, default: '/var/log/docker.log'

    # docker-wait-ready timeout
    property :service_timeout, Integer, default: 20

    allowed_actions :start, :stop, :restart

    alias_method :label, :labels
    alias_method :run_group, :group
    alias_method :graph, :data_root

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
            service_timeout: new_resource.service_timeout
          )
          cookbook 'docker'
          action :create
        end
      end
    end
  end
end
