module DockerCookbook
  class DockerContainer < DockerBase
    require 'docker'
    require 'shellwords'
    require_relative 'helpers_container'

    include DockerHelpers::Container

    resource_name :docker_container

    ###########################################################
    # In Chef 12.5 and later, we no longer have to use separate
    # classes for resource and providers. Instead, we have
    # everything in a single class.
    #
    # For the purposes of my own sanity, I'm going to place all the
    # "resource" related bits at the top of the files, and the
    # providerish bits at the bottom.
    #
    #
    # Methods for default values and coersion are found in
    # helpers_container.rb
    ###########################################################

    # ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~
    # Begin classic Chef "resource" section
    # ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~

    # The non-standard types Boolean, ArrayType, ShellCommand, etc
    # are found in the DockerBase class.
    property :container_name, String, name_property: true
    property :repo, String, default: lazy { container_name }
    property :tag, String, default: 'latest'
    property :command, ShellCommand
    property :attach_stderr, Boolean, default: false, desired_state: false
    property :attach_stdin, Boolean, default: false, desired_state: false
    property :attach_stdout, Boolean, default: false, desired_state: false
    property :autoremove, Boolean, desired_state: false
    property :cap_add, NonEmptyArray
    property :cap_drop, NonEmptyArray
    property :cgroup_parent, String, default: ''
    property :cpu_shares, [Integer, nil], default: 0
    property :cpuset_cpus, String, default: ''
    property :detach, Boolean, default: true, desired_state: false
    property :devices, Array, default: []
    property :dns, Array, default: []
    property :dns_search, Array, default: []
    property :domain_name, String, default: ''
    property :entrypoint, ShellCommand
    property :env, UnorderedArrayType, default: []
    property :extra_hosts, NonEmptyArray
    property :exposed_ports, PartialHashType, default: {}
    property :force, Boolean, desired_state: false
    property :host, [String, nil], default: lazy { default_host }, desired_state: false
    property :hostname, String
    property :ipc_mode, String, default: ''
    property :labels, [String, Array, Hash], default: {}, coerce: proc { |v| coerce_labels(v) }
    property :links, UnorderedArrayType, coerce: proc { |v| coerce_links(v) }
    property :log_driver, %w( json-file syslog journald gelf fluentd awslogs splunk etwlogs gcplogs none ), default: 'json-file', desired_state: false
    property :log_opts, [Hash, nil], coerce: proc { |v| coerce_log_opts(v) }, desired_state: false
    property :ip_address, String
    property :mac_address, String
    property :memory, Integer, default: 0
    property :memory_swap, Integer, default: 0
    property :network_disabled, Boolean, default: false
    property :network_mode, [String, NilClass], default: 'bridge'
    property :open_stdin, Boolean, default: false, desired_state: false
    property :outfile, [String, NilClass]
    property :port_bindings, PartialHashType, default: {}
    property :pid_mode, String, default: ''
    property :privileged, Boolean, default: false
    property :publish_all_ports, Boolean, default: false
    property :remove_volumes, Boolean
    property :restart_maximum_retry_count, Integer, default: 0
    property :restart_policy, String
    property :ro_rootfs, Boolean, default: false
    property :security_opts, [String, ArrayType]
    property :signal, String, default: 'SIGTERM'
    property :stdin_once, Boolean, default: false, desired_state: false
    property :sysctls, Hash, default: {}
    property :timeout, [Integer, nil], desired_state: false
    property :tty, Boolean, default: false
    property :ulimits, [Array, nil], coerce: proc { |v| coerce_ulimits(v) }
    property :user, String, default: ''
    property :userns_mode, String, default: ''
    property :uts_mode, String, default: ''
    property :volumes, PartialHashType, default: {}, coerce: proc { |v| coerce_volumes(v) }
    property :volumes_from, ArrayType
    property :volume_driver, String
    property :working_dir, [String, NilClass], default: ''

    # Used to store the bind property since binds is an alias to volumes
    property :volumes_binds, Array

    # Used to store the state of the Docker container
    property :container, Docker::Container, desired_state: false

    # Used by :stop action. If the container takes longer than this
    # many seconds to stop, kill itinstead. -1 (the default) means
    # never kill the container.
    property :kill_after, Numeric, default: -1, desired_state: false

    alias cmd command
    alias additional_host extra_hosts
    alias rm autoremove
    alias remove_automatically autoremove
    alias host_name hostname
    alias domainname domain_name
    alias dnssearch dns_search
    alias restart_maximum_retries restart_maximum_retry_count
    alias volume volumes
    alias binds volumes
    alias volume_from volumes_from
    alias destination outfile
    alias workdir working_dir

    # ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~
    # Begin classic Chef "provider" section
    # ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~

    ########################################################
    # Load Current Value
    ########################################################

    load_current_value do
      # Grab the container and assign the container property
      begin
        with_retries { container Docker::Container.get(container_name, {}, connection) }
      rescue Docker::Error::NotFoundError
        current_value_does_not_exist!
      end

      # Go through everything in the container and set corresponding properties:
      # c.info['Config']['ExposedPorts'] -> exposed_ports
      (container.info['Config'].to_a + container.info['HostConfig'].to_a).each do |key, value|
        next if value.nil? || key == 'RestartPolicy' || key == 'Binds' || key == 'ReadonlyRootfs'

        # Image => image
        # Set exposed_ports = ExposedPorts (etc.)
        property_name = to_snake_case(key)
        public_send(property_name, value) if respond_to?(property_name)
      end

      # load container specific labels (without engine/image ones)
      load_container_labels

      # these are a special case for us because our names differ from theirs
      restart_policy container.info['HostConfig']['RestartPolicy']['Name']
      restart_maximum_retry_count container.info['HostConfig']['RestartPolicy']['MaximumRetryCount']
      volumes_binds container.info['HostConfig']['Binds']
      ro_rootfs container.info['HostConfig']['ReadonlyRootfs']
    end

    #########
    # Actions
    #########

    # Super handy visual reference!
    # http://gliderlabs.com/images/docker_events.png

    default_action :run

    declare_action_class.class_eval do
      def whyrun_supported?
        true
      end

      def call_action(action)
        send("action_#{action}")
        load_current_resource
      end

      def state
        current_resource ? current_resource.state : {}
      end
    end

    # Loads container specific labels excluding those of engine or image.
    # This insures idempotency.
    def load_container_labels
      image_labels = Docker::Image.get(container.info['Image'], {}, connection).info['Config']['Labels'] || {}
      engine_labels = Docker.info(connection)['Labels'] || {}

      labels = (container.info['Config']['Labels'] || {}).reject do |key, val|
        image_labels.any? { |k, v| k == key && v == val } ||
          engine_labels.any? { |k, v| k == key && v == val }
      end

      public_send(:labels, labels)
    end

    def validate_container_create
      if property_is_set?(:restart_policy) &&
         restart_policy != 'no' &&
         restart_policy != 'always' &&
         restart_policy != 'unless-stopped' &&
         restart_policy != 'on-failure'
        raise Chef::Exceptions::ValidationFailed, 'restart_policy must be either no, always, unless-stopped, or on-failure.'
      end

      if autoremove == true && (property_is_set?(:restart_policy) && restart_policy != 'no')
        raise Chef::Exceptions::ValidationFailed, 'Conflicting options restart_policy and autoremove.'
      end

      if detach == true &&
         (
          attach_stderr == true ||
          attach_stdin == true ||
          attach_stdout == true ||
          stdin_once == true
         )
        raise Chef::Exceptions::ValidationFailed, 'Conflicting options detach, attach_stderr, attach_stdin, attach_stdout, stdin_once.'
      end

      if network_mode == 'host' &&
         (
          !(hostname.nil? || hostname.empty?) ||
          !(mac_address.nil? || mac_address.empty?)
         )
        raise Chef::Exceptions::ValidationFailed, 'Cannot specify hostname or mac_address when network_mode is host.'
      end

      if network_mode == 'container' &&
         (
          !(hostname.nil? || hostname.empty?) ||
          !(dns.nil? || dns.empty?) ||
          !(dns_search.nil? || dns_search.empty?) ||
          !(mac_address.nil? || mac_address.empty?) ||
          !(extra_hosts.nil? || extra_hosts.empty?) ||
          !(exposed_ports.nil? || exposed_ports.empty?) ||
          !(port_bindings.nil? || port_bindings.empty?) ||
          !(publish_all_ports.nil? || publish_all_ports.empty?) ||
          !port.nil?
         )
        raise Chef::Exceptions::ValidationFailed, 'Cannot specify hostname, dns, dns_search, mac_address, extra_hosts, exposed_ports, port_bindings, publish_all_ports, port when network_mode is container.'
      end
    end

    def parsed_hostname
      return nil if network_mode == 'host'
      hostname
    end

    action :create do
      validate_container_create

      converge_if_changed do
        action_delete

        with_retries do
          config = {
            'name'            => container_name,
            'Image'           => "#{repo}:#{tag}",
            'Labels'          => labels,
            'Cmd'             => to_shellwords(command),
            'AttachStderr'    => attach_stderr,
            'AttachStdin'     => attach_stdin,
            'AttachStdout'    => attach_stdout,
            'Domainname'      => domain_name,
            'Entrypoint'      => to_shellwords(entrypoint),
            'Env'             => env,
            'ExposedPorts'    => exposed_ports,
            'Hostname'        => parsed_hostname,
            'MacAddress'      => mac_address,
            'NetworkDisabled' => network_disabled,
            'OpenStdin'       => open_stdin,
            'StdinOnce'       => stdin_once,
            'Tty'             => tty,
            'User'            => user,
            'Volumes'         => volumes,
            'WorkingDir'      => working_dir,
            'HostConfig'      => {
              'Binds'           => volumes_binds,
              'CapAdd'          => cap_add,
              'CapDrop'         => cap_drop,
              'CgroupParent'    => cgroup_parent,
              'CpuShares'       => cpu_shares,
              'CpusetCpus'      => cpuset_cpus,
              'Devices'         => devices,
              'Dns'             => dns,
              'DnsSearch'       => dns_search,
              'ExtraHosts'      => extra_hosts,
              'IpcMode'         => ipc_mode,
              'Links'           => links,
              'LogConfig'       => log_config,
              'Memory'          => memory,
              'MemorySwap'      => memory_swap,
              'NetworkMode'     => network_mode,
              'Privileged'      => privileged,
              'PidMode'         => pid_mode,
              'PortBindings'    => port_bindings,
              'PublishAllPorts' => publish_all_ports,
              'RestartPolicy'   => {
                'Name'              => restart_policy,
                'MaximumRetryCount' => restart_maximum_retry_count,
              },
              'ReadonlyRootfs'  => ro_rootfs,
              'Sysctls'         => sysctls,
              'Ulimits'         => ulimits_to_hash,
              'UsernsMode'      => userns_mode,
              'UTSMode'         => uts_mode,
              'VolumesFrom'     => volumes_from,
              'VolumeDriver'    => volume_driver,
            },
          }
          net_config = {
            'NetworkingConfig' => {
              'EndpointsConfig' => {
                network_mode => {
                  'IPAMConfig' => {
                    'IPv4Address' => ip_address,
                  },
                },
              },
            },
          } if network_mode
          config.merge! net_config

          Docker::Container.create(config, connection)
        end
      end
    end

    action :start do
      return if state['Restarting']
      return if state['Running']
      converge_by "starting #{container_name}" do
        with_retries do
          container.start
          timeout ? container.wait(timeout) : container.wait unless detach
        end
        wait_running_state(true) if detach
      end
    end

    action :stop do
      return unless state['Running']
      kill_after_str = " (will kill after #{kill_after}s)" if kill_after != -1
      converge_by "stopping #{container_name} #{kill_after_str}" do
        begin
          with_retries do
            container.stop!('timeout' => kill_after)
            wait_running_state(false)
          end
        rescue Docker::Error::TimeoutError
          raise Docker::Error::TimeoutError, "Container failed to stop, consider adding kill_after to the container #{container_name}"
        end
      end
    end

    action :kill do
      return unless state['Running']
      converge_by "killing #{container_name}" do
        with_retries { container.kill(signal: signal) }
      end
    end

    action :run do
      validate_container_create
      call_action(:create)
      call_action(:start)
      call_action(:delete) if autoremove
    end

    action :run_if_missing do
      return if current_resource
      call_action(:run)
    end

    action :pause do
      return if state['Paused']
      converge_by "pausing #{container_name}" do
        with_retries { container.pause }
      end
    end

    action :unpause do
      return if current_resource && !state['Paused']
      converge_by "unpausing #{container_name}" do
        with_retries { container.unpause }
      end
    end

    action :restart do
      kill_after_str = " (will kill after #{kill_after}s)" if kill_after != -1
      converge_by "restarting #{container_name} #{kill_after_str}" do
        current_resource ? container.restart('timeout' => kill_after) : call_action(:run)
      end
    end

    action :reload do
      converge_by "reloading #{container_name}" do
        with_retries { container.kill(signal: 'SIGHUP') }
      end
    end

    action :redeploy do
      validate_container_create

      # never start containers resulting from a previous action :create #432
      should_create = state['Running'] == false && state['StartedAt'] == '0001-01-01T00:00:00Z'
      call_action(:delete)
      call_action(should_create ? :create : :run)
    end

    action :delete do
      return unless current_resource
      call_action(:unpause)
      call_action(:stop)
      converge_by "deleting #{container_name}" do
        with_retries { container.delete(force: force, v: remove_volumes) }
      end
    end

    action :remove do
      call_action(:delete)
    end

    action :commit do
      converge_by "committing #{container_name}" do
        with_retries do
          new_image = container.commit
          new_image.tag('repo' => repo, 'tag' => tag, 'force' => force)
        end
      end
    end

    action :export do
      raise "Please set outfile property on #{container_name}" if outfile.nil?
      converge_by "exporting #{container_name}" do
        with_retries do
          ::File.open(outfile, 'w') { |f| container.export { |chunk| f.write(chunk) } }
        end
      end
    end
  end
end
