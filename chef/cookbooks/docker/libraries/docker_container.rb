module DockerCookbook
  class DockerContainer < DockerBase
    resource_name :docker_container

    property :container_name, String, name_property: true
    property :repo, String, default: lazy { container_name }
    property :tag, String, default: 'latest'
    property :command, [Array, String, nil], coerce: proc { |v| v.is_a?(String) ? ::Shellwords.shellwords(v) : v }
    property :attach_stderr, [TrueClass, FalseClass], default: false, desired_state: false
    property :attach_stdin, [TrueClass, FalseClass], default: false, desired_state: false
    property :attach_stdout, [TrueClass, FalseClass], default: false, desired_state: false
    property :autoremove, [TrueClass, FalseClass], default: false, desired_state: false
    property :cap_add, [Array, nil], coerce: proc { |v| Array(v).empty? ? nil : Array(v) }
    property :cap_drop, [Array, nil], coerce: proc { |v| Array(v).empty? ? nil : Array(v) }
    property :cgroup_parent, String, default: ''
    property :cpu_shares, Integer, default: 0
    property :cpuset_cpus, String, default: ''
    property :detach, [TrueClass, FalseClass], default: true, desired_state: false
    property :devices, Array, default: []
    property :dns, Array, default: []
    property :dns_search, Array, default: []
    property :domain_name, String, default: ''
    property :entrypoint, [Array, String, nil], coerce: proc { |v| v.is_a?(String) ? ::Shellwords.shellwords(v) : v }
    property :env, UnorderedArrayType, default: []
    property :env_file, [Array, String], coerce: proc { |v| coerce_env_file(v) }, default: [], desired_state: false
    property :extra_hosts, [Array, nil], coerce: proc { |v| Array(v).empty? ? nil : Array(v) }
    property :exposed_ports, PartialHashType, default: {}
    property :force, [TrueClass, FalseClass], default: false, desired_state: false
    property :health_check, Hash, default: {}
    property :host, [String, nil], default: lazy { ENV['DOCKER_HOST'] }, desired_state: false
    property :hostname, String
    property :ipc_mode, String, default: ''
    property :kernel_memory, [String, Integer], coerce: proc { |v| coerce_to_bytes(v) }, default: 0
    property :labels, [String, Array, Hash], default: {}, coerce: proc { |v| coerce_labels(v) }
    property :links, UnorderedArrayType, coerce: proc { |v| coerce_links(v) }
    property :log_driver, %w( json-file syslog journald gelf fluentd awslogs splunk etwlogs gcplogs none ), default: 'json-file', desired_state: false
    property :log_opts, [Hash, nil], coerce: proc { |v| coerce_log_opts(v) }, desired_state: false
    property :init, [TrueClass, FalseClass, nil]
    property :ip_address, String
    property :mac_address, String
    property :memory, [String, Integer], coerce: proc { |v| coerce_to_bytes(v) }, default: 0
    property :memory_swap, [String, Integer], coerce: proc { |v| coerce_to_bytes(v) }, default: 0
    property :memory_swappiness, Integer, default: 0
    property :memory_reservation, Integer, coerce: proc { |v| coerce_to_bytes(v) }, default: 0
    property :network_disabled, [TrueClass, FalseClass], default: false
    property :network_mode, String, default: 'bridge'
    property :network_aliases, [String, Array], default: [], coerce: proc { |v| Array(v) }
    property :oom_kill_disable, [TrueClass, FalseClass], default: false
    property :oom_score_adj, Integer, default: -500
    property :open_stdin, [TrueClass, FalseClass], default: false, desired_state: false
    property :outfile, String
    property :port_bindings, PartialHashType, default: {}
    property :pid_mode, String, default: ''
    property :privileged, [TrueClass, FalseClass], default: false
    property :publish_all_ports, [TrueClass, FalseClass], default: false
    property :remove_volumes, [TrueClass, FalseClass], default: false
    property :restart_maximum_retry_count, Integer, default: 0
    property :restart_policy, String
    property :runtime, String, default: 'runc'
    property :ro_rootfs, [TrueClass, FalseClass], default: false
    property :security_opt, [String, Array], coerce: proc { |v| v.nil? ? nil : Array(v) }
    property :shm_size, [String, Integer], default: '64m', coerce: proc { |v| coerce_to_bytes(v) }
    property :signal, String, default: 'SIGTERM'
    property :stdin_once, [TrueClass, FalseClass], default: false, desired_state: false
    property :sysctls, Hash, default: {}
    property :timeout, Integer, desired_state: false
    property :tty, [TrueClass, FalseClass], default: false
    property :ulimits, [Array, nil], coerce: proc { |v| coerce_ulimits(v) }
    property :user, String, default: ''
    property :userns_mode, String, default: ''
    property :uts_mode, String, default: ''
    property :volumes, PartialHashType, default: {}, coerce: proc { |v| coerce_volumes(v) }
    property :volumes_from, [String, Array], coerce: proc { |v| v.nil? ? nil : Array(v) }
    property :volume_driver, String
    property :working_dir, String, default: ''

    # Used to store the bind property since binds is an alias to volumes
    property :volumes_binds, Array

    # Used to store the state of the Docker container
    property :container, Docker::Container, desired_state: false

    # Used to store the state of the Docker container create options
    property :create_options, Hash, default: {}, desired_state: false

    # Used by :stop action. If the container takes longer than this
    # many seconds to stop, kill it instead. A nil value (the default) means
    # never kill the container.
    property :kill_after, [Integer, NilClass], default: nil, desired_state: false

    alias_method :cmd, :command
    alias_method :additional_host, :extra_hosts
    alias_method :rm, :autoremove
    alias_method :remove_automatically, :autoremove
    alias_method :host_name, :hostname
    alias_method :domainname, :domain_name
    alias_method :dnssearch, :dns_search
    alias_method :restart_maximum_retries, :restart_maximum_retry_count
    alias_method :volume, :volumes
    alias_method :binds, :volumes
    alias_method :volume_from, :volumes_from
    alias_method :destination, :outfile
    alias_method :workdir, :working_dir

    ###################
    # Property helpers
    ###################

    def coerce_labels(v)
      case v
      when Hash, nil
        v
      else
        Array(v).each_with_object({}) do |label, h|
          parts = label.split(':')
          h[parts[0]] = parts[1..-1].join(':')
        end
      end
    end

    def coerce_links(v)
      case v
      when DockerBase::UnorderedArray, nil
        v
      else
        return nil if v.empty?
        # Parse docker input of /source:/container_name/dest into source:dest
        DockerBase::UnorderedArray.new(Array(v)).map! do |link|
          if link =~ %r{^/(?<source>.+):/#{name}/(?<dest>.+)}
            link = "#{Regexp.last_match[:source]}:#{Regexp.last_match[:dest]}"
          end
          link
        end
      end
    end

    def to_bytes(v)
      n = v.to_i
      u = v.gsub(/\d/, '').upcase

      multiplier = case u
                   when 'B'
                     1
                   when 'K'
                     1024**1
                   when 'M'
                     1024**2
                   when 'G'
                     1024**3
                   when 'T'
                     1024**4
                   when 'P'
                     1024**5
                   when 'E'
                     1024**6
                   when 'Z'
                     1024**7
                   when 'Y'
                     1024**8
                   else
                     1
                   end

      n * multiplier
    end

    def coerce_to_bytes(v)
      case v
      when Integer, nil
        v
      else
        to_bytes(v)
      end
    end

    def coerce_log_opts(v)
      case v
      when Hash, nil
        v
      else
        Array(v).each_with_object({}) do |log_opt, memo|
          key, value = log_opt.split('=', 2)
          memo[key] = value
        end
      end
    end

    def coerce_ulimits(v)
      return v if v.nil?
      Array(v).map do |u|
        u = "#{u['Name']}=#{u['Soft']}:#{u['Hard']}" if u.is_a?(Hash)
        u
      end
    end

    def coerce_volumes(v)
      case v
      when DockerBase::PartialHash, nil
        v
      when Hash
        DockerBase::PartialHash[v]
      else
        b = []
        v = Array(v).to_a # in case v.is_A?(Chef::Node::ImmutableArray)
        v.delete_if do |x|
          parts = x.split(':')
          b << x if parts.length > 1
        end
        b = nil if b.empty?
        volumes_binds b
        return DockerBase::PartialHash.new if v.empty?
        v.each_with_object(DockerBase::PartialHash.new) { |volume, h| h[volume] = {} }
      end
    end

    def state
      # Always return the latest state, see #510
      Docker::Container.get(container_name, {}, connection).info['State']
    rescue StandardError
      {}
    end

    def wait_running_state(v)
      tries = running_wait_time
      tries.times do
        return if state['Running'] == v
        sleep 1
      end
      return if state['Running'] == v

      # Container failed to reach correct state: Throw an error
      desired_state_str = v ? 'running' : 'not running'
      raise Docker::Error::TimeoutError, "Container #{container_name} failed to change to #{desired_state_str} state after #{tries} seconds"
    end

    def port(v = nil)
      return @port if v.nil?
      exposed_ports coerce_exposed_ports(v)
      port_bindings coerce_port_bindings(v)
      @port = v
      @port
    end

    def parse_port(v)
      _, protocol = v.split('/')
      parts = v.split(':')
      case parts.length
      when 3
        host_ip = parts[0]
        host_port = parts[1].split('-')
        container_port = parts[2].split('-')
      when 2
        host_ip = '0.0.0.0'
        host_port = parts[0].split('-')
        container_port = parts[1].split('-')
      when 1
        host_ip = ''
        host_port = ['']
        container_port = parts[0].split('-')
      end
      host_port.map!(&:to_i) unless host_port == ['']
      container_port.map!(&:to_i)
      if host_port.count > 1
        Chef::Log.fatal("FATAL: Invalid port range! #{host_port}") if host_port[0] > host_port[1]
        host_port = (host_port[0]..host_port[1]).to_a
      end
      if container_port.count > 1
        Chef::Log.fatal("FATAL: Invalid port range! #{container_port}") if container_port[0] > container_port[1]
        container_port = (container_port[0]..container_port[1]).to_a
      end
      Chef::Log.fatal('FATAL: Port range size does not match!') if host_port.count > 1 && host_port.count != container_port.count
      # qualify the port-binding protocol even when it is implicitly tcp #427.
      protocol = 'tcp' if protocol.nil?
      Array(container_port).map.with_index do |_, i|
        {
          'host_ip' => host_ip,
          'host_port' => host_port[i].to_s,
          'container_port' => "#{container_port[i]}/#{protocol}",
        }
      end
    end

    def coerce_exposed_ports(v)
      case v
      when Hash, nil
        v
      else
        x = Array(v).map { |a| parse_port(a) }
        x.flatten!
        x.each_with_object({}) do |y, h|
          h[y['container_port']] = {}
        end
      end
    end

    def coerce_port_bindings(v)
      case v
      when Hash, nil
        v
      else
        x = Array(v).map { |a| parse_port(a) }
        x.flatten!
        x.each_with_object({}) do |y, h|
          h[y['container_port']] = [] unless h[y['container_port']]
          h[y['container_port']] << {
            'HostIp' => y['host_ip'],
            'HostPort' => y['host_port'],
          }
        end
      end
    end

    def coerce_env_file(v)
      return v if v.empty?
      Array(v).map { |f| ::File.readlines(f).map(&:strip) }.flatten
    end

    # log_driver and log_opts really handle this
    def log_config(value = Chef::NOT_PASSED)
      if value != Chef::NOT_PASSED
        @log_config = value
        log_driver value['Type']
        log_opts value['Config']
      end
      return @log_config if defined?(@log_config)
      def_logcfg = {}
      def_logcfg['Type'] = log_driver if property_is_set?(:log_driver)
      def_logcfg['Config'] = log_opts if property_is_set?(:log_opts)
      def_logcfg = nil if def_logcfg.empty?
      def_logcfg
    end

    # TODO: test image property in serverspec and kitchen, not only in rspec
    # for full specs of image parsing, see spec/helpers_container_spec.rb
    #
    # If you say:    `repo 'blah'`
    # Image will be: `blah:latest`
    #
    # If you say:    `repo 'blah'; tag '3.1'`
    # Image will be: `blah:3.1`
    #
    # If you say:    `image 'blah'`
    # Repo will be:  `blah`
    # Tag will be:   `latest`
    #
    # If you say:    `image 'blah:3.1'`
    # Repo will be:  `blah`
    # Tag will be:   `3.1`
    #
    # If you say:    `image 'repo/blah'`
    # Repo will be:  `repo/blah`
    # Tag will be:   `latest`
    #
    # If you say:    `image 'repo/blah:3.1'`
    # Repo will be:  `repo/blah`
    # Tag will be:   `3.1`
    #
    # If you say:    `image 'repo:1337/blah'`
    # Repo will be:  `repo:1337/blah`
    # Tag will be:   `latest'
    #
    # If you say:    `image 'repo:1337/blah:3.1'`
    # Repo will be:  `repo:1337/blah`
    # Tag will be:   `3.1`
    #
    def image(image = nil)
      if image
        if image.include?('/')
          # pathological case, a ':' may be present which starts the 'port'
          # part of the image name and not a tag. example: 'host:1337/blah'
          # fortunately, tags are only found in the 'basename' part of image
          # so we can split on '/' and rebuild once the tag has been parsed.
          dirname, _, basename = image.rpartition('/')
          r, t = basename.split(':', 2)
          r = [dirname, r].join('/')
        else
          # normal case, the ':' starts the tag part
          r, t = image.split(':', 2)
        end
        repo r
        tag t if t
      end
      "#{repo}:#{tag}"
    end

    def to_shellwords(command)
      command.is_a?(String) ? ::Shellwords.shellwords(command) : command
    end

    ######################
    # Load Current Value
    ######################

    def to_snake_case(name)
      # ExposedPorts -> _exposed_ports
      name = name.gsub(/[A-Z]/) { |x| "_#{x.downcase}" }
      # _exposed_ports -> exposed_ports
      name = name[1..-1] if name.start_with?('_')
      name
    end

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
      ip_address ip_address_from_container_networks(container) unless ip_address_from_container_networks(container).nil?
    end

    # Gets the ip address from the existing container
    # current docker api of 1.16 does not have ['NetworkSettings']['Networks']
    # For docker > 1.21 - use ['NetworkSettings']['Networks']
    #
    #   @param container [Docker::Container] A container object
    #   @returns [String] An ip_address
    def ip_address_from_container_networks(container)
      # We use the first value in 'Networks'
      # We can't assume it will be 'bridged'
      # It might also not match the new_resource value
      if container.info['NetworkSettings'] &&
         container.info['NetworkSettings']['Networks'] &&
         container.info['NetworkSettings']['Networks'].values[0] &&
         container.info['NetworkSettings']['Networks'].values[0]['IPAMConfig'] &&
         container.info['NetworkSettings']['Networks'].values[0]['IPAMConfig']['IPv4Address']
        # Return the ip address listed
        container.info['NetworkSettings']['Networks'].values[0]['IPAMConfig']['IPv4Address']
      end
    end

    #########
    # Actions
    #########

    # Super handy visual reference!
    # http://gliderlabs.com/images/docker_events.png

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

    action :run do
      validate_container_create
      call_action(:create)
      call_action(:start)
      call_action(:delete) if new_resource.autoremove
    end

    action :create do
      validate_container_create

      converge_if_changed do
        action_delete

        with_retries do
          config = {
            'name'            => new_resource.container_name,
            'Image'           => "#{new_resource.repo}:#{new_resource.tag}",
            'Labels'          => new_resource.labels,
            'Cmd'             => to_shellwords(new_resource.command),
            'AttachStderr'    => new_resource.attach_stderr,
            'AttachStdin'     => new_resource.attach_stdin,
            'AttachStdout'    => new_resource.attach_stdout,
            'Domainname'      => new_resource.domain_name,
            'Entrypoint'      => to_shellwords(new_resource.entrypoint),
            'Env'             => new_resource.env + new_resource.env_file,
            'ExposedPorts'    => new_resource.exposed_ports,
            'Hostname'        => parsed_hostname,
            'MacAddress'      => new_resource.mac_address,
            'NetworkDisabled' => new_resource.network_disabled,
            'OpenStdin'       => new_resource.open_stdin,
            'StdinOnce'       => new_resource.stdin_once,
            'Tty'             => new_resource.tty,
            'User'            => new_resource.user,
            'Volumes'         => new_resource.volumes,
            'WorkingDir'      => new_resource.working_dir,
            'HostConfig'      => {
              'Binds'           => new_resource.volumes_binds,
              'CapAdd'          => new_resource.cap_add,
              'CapDrop'         => new_resource.cap_drop,
              'CgroupParent'    => new_resource.cgroup_parent,
              'CpuShares'       => new_resource.cpu_shares,
              'CpusetCpus'      => new_resource.cpuset_cpus,
              'Devices'         => new_resource.devices,
              'Dns'             => new_resource.dns,
              'DnsSearch'       => new_resource.dns_search,
              'ExtraHosts'      => new_resource.extra_hosts,
              'IpcMode'         => new_resource.ipc_mode,
              'Init'            => new_resource.init,
              'KernelMemory'    => new_resource.kernel_memory,
              'Links'           => new_resource.links,
              'LogConfig'       => log_config,
              'Memory'          => new_resource.memory,
              'MemorySwap'      => new_resource.memory_swap,
              'MemorySwappiness' => new_resource.memory_swappiness,
              'MemoryReservation' => new_resource.memory_reservation,
              'NetworkMode'     => new_resource.network_mode,
              'OomKillDisable'  => new_resource.oom_kill_disable,
              'OomScoreAdj'     => new_resource.oom_score_adj,
              'Privileged'      => new_resource.privileged,
              'PidMode'         => new_resource.pid_mode,
              'PortBindings'    => new_resource.port_bindings,
              'PublishAllPorts' => new_resource.publish_all_ports,
              'RestartPolicy'   => {
                'Name'              => new_resource.restart_policy,
                'MaximumRetryCount' => new_resource.restart_maximum_retry_count,
              },
              'ReadonlyRootfs'  => new_resource.ro_rootfs,
              'Runtime'         => new_resource.runtime,
              'SecurityOpt'     => new_resource.security_opt,
              'ShmSize'         => new_resource.shm_size,
              'Sysctls'         => new_resource.sysctls,
              'Ulimits'         => ulimits_to_hash,
              'UsernsMode'      => new_resource.userns_mode,
              'UTSMode'         => new_resource.uts_mode,
              'VolumesFrom'     => new_resource.volumes_from,
              'VolumeDriver'    => new_resource.volume_driver,
            },
          }
          net_config = {
            'NetworkingConfig' => {
              'EndpointsConfig' => {
                new_resource.network_mode => {
                  'IPAMConfig' => {
                    'IPv4Address' => new_resource.ip_address,
                  },
                  'Aliases' => new_resource.network_aliases,
                },
              },
            },
          } if new_resource.network_mode
          config.merge! net_config

          # Remove any options not supported in windows
          if platform?('windows')
            config['HostConfig'].delete('MemorySwappiness')
          end

          unless new_resource.health_check.empty?
            config['Healthcheck'] = new_resource.health_check
          end

          # Store the state of the options and create the container
          new_resource.create_options = config
          Docker::Container.create(config, connection)
        end
      end
    end

    action :start do
      return if state['Restarting']
      return if state['Running']
      converge_by "starting #{new_resource.container_name}" do
        with_retries do
          current_resource.container.start

          unless new_resource.detach
            new_resource.timeout ? current_resource.container.wait(new_resource.timeout) : current_resource.container.wait
          end
        end
        wait_running_state(true) if new_resource.detach
      end
    end

    action :stop do
      return unless state['Running']
      kill_after_str = "(will kill after #{new_resource.kill_after}s)" if new_resource.kill_after
      converge_by "stopping #{new_resource.container_name} #{kill_after_str}" do
        begin
          with_retries do
            current_resource.container.stop!('timeout' => new_resource.kill_after)
            wait_running_state(false)
          end
        rescue Docker::Error::TimeoutError
          raise Docker::Error::TimeoutError, "Container failed to stop, consider adding kill_after to the container #{new_resource.container_name}"
        end
      end
    end

    action :kill do
      return unless state['Running']
      converge_by "killing #{new_resource.container_name}" do
        with_retries { current_resource.container.kill(signal: new_resource.signal) }
      end
    end

    action :run_if_missing do
      return if current_resource
      call_action(:run)
    end

    action :pause do
      return if state['Paused']
      converge_by "pausing #{new_resource.container_name}" do
        with_retries { current_resource.container.pause }
      end
    end

    action :unpause do
      return if current_resource && !state['Paused']
      converge_by "unpausing #{new_resource.container_name}" do
        with_retries { current_resource.container.unpause }
      end
    end

    action :restart do
      kill_after_str = " (will kill after #{new_resource.kill_after}s)" if new_resource.kill_after != -1
      converge_by "restarting #{new_resource.container_name} #{kill_after_str}" do
        current_resource ? current_resource.container.restart('timeout' => new_resource.kill_after) : call_action(:run)
      end
    end

    action :reload do
      converge_by "reloading #{new_resource.container_name}" do
        with_retries { current_resource.container.kill(signal: 'SIGHUP') }
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
      converge_by "deleting #{new_resource.container_name}" do
        with_retries { current_resource.container.delete(force: new_resource.force, v: new_resource.remove_volumes) }
      end
    end

    action :remove do
      call_action(:delete)
    end

    action :commit do
      converge_by "committing #{new_resource.container_name}" do
        with_retries do
          new_image = current_resource.container.commit
          new_image.tag('repo' => new_resource.repo, 'tag' => new_resource.tag, 'force' => new_resource.force)
        end
      end
    end

    action :export do
      raise "Please set outfile property on #{new_resource.container_name}" if new_resource.outfile.nil?
      converge_by "exporting #{new_resource.container_name}" do
        with_retries do
          ::File.open(new_resource.outfile, 'w') { |f| current_resource.container.export { |chunk| f.write(chunk) } }
        end
      end
    end

    declare_action_class.class_eval do
      def validate_container_create
        if new_resource.property_is_set?(:restart_policy) &&
           new_resource.restart_policy != 'no' &&
           new_resource.restart_policy != 'always' &&
           new_resource.restart_policy != 'unless-stopped' &&
           new_resource.restart_policy != 'on-failure'
          raise Chef::Exceptions::ValidationFailed, 'restart_policy must be either no, always, unless-stopped, or on-failure.'
        end

        if new_resource.autoremove == true && (new_resource.property_is_set?(:restart_policy) && restart_policy != 'no')
          raise Chef::Exceptions::ValidationFailed, 'Conflicting options restart_policy and autoremove.'
        end

        if new_resource.detach == true &&
           (
             new_resource.attach_stderr == true ||
             new_resource.attach_stdin == true ||
             new_resource.attach_stdout == true ||
             new_resource.stdin_once == true
           )
          raise Chef::Exceptions::ValidationFailed, 'Conflicting options detach, attach_stderr, attach_stdin, attach_stdout, stdin_once.'
        end

        if new_resource.network_mode == 'host' &&
           (
             !(new_resource.hostname.nil? || new_resource.hostname.empty?) ||
             !(new_resource.mac_address.nil? || new_resource.mac_address.empty?)
           )
          raise Chef::Exceptions::ValidationFailed, 'Cannot specify hostname or mac_address when network_mode is host.'
        end

        if new_resource.network_mode == 'container' &&
           (
             !(new_resource.hostname.nil? || new_resource.hostname.empty?) ||
               !(new_resource.dns.nil? || new_resource.dns.empty?) ||
               !(new_resource.dns_search.nil? || new_resource.dns_search.empty?) ||
               !(new_resource.mac_address.nil? || new_resource.mac_address.empty?) ||
               !(new_resource.extra_hosts.nil? || new_resource.extra_hosts.empty?) ||
               !(new_resource.exposed_ports.nil? || new_resource.exposed_ports.empty?) ||
               !(new_resource.port_bindings.nil? || new_resource.port_bindings.empty?) ||
               !(new_resource.publish_all_ports.nil? || new_resource.publish_all_ports.empty?) ||
               !new_resource.port.nil?
           )
          raise Chef::Exceptions::ValidationFailed, 'Cannot specify hostname, dns, dns_search, mac_address, extra_hosts, exposed_ports, port_bindings, publish_all_ports, port when network_mode is container.'
        end
      end

      def parsed_hostname
        return nil if new_resource.network_mode == 'host'
        new_resource.hostname
      end

      def call_action(action)
        send("action_#{action}")
        load_current_resource
      end

      def state
        current_resource ? current_resource.state : {}
      end

      def ulimits_to_hash
        return nil if new_resource.ulimits.nil?
        new_resource.ulimits.map do |u|
          name = u.split('=')[0]
          soft = u.split('=')[1].split(':')[0]
          hard = u.split('=')[1].split(':')[1]
          { 'Name' => name, 'Soft' => soft.to_i, 'Hard' => hard.to_i }
        end
      end
    end
  end
end
