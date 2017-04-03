module DockerCookbook
  class DockerNetwork < DockerBase
    require 'docker'
    require_relative 'helpers_network'
    include DockerHelpers::Network

    resource_name :docker_network

    property :auxiliary_addresses, [String, Array, nil], coerce: proc { |v| coerce_auxiliary_addresses(v) }
    property :container, String, desired_state: false
    property :driver, String
    property :driver_opts, PartialHashType
    property :gateway, [String, Array, nil], coerce: proc { |v| coerce_gateway(v) }
    property :host, [String, nil], default: lazy { default_host }, desired_state: false
    property :id, String
    property :ip_range, [String, Array, nil], coerce: proc { |v| coerce_ip_range(v) }
    property :ipam_driver, String
    property :network, Docker::Network, desired_state: false
    property :network_name, String, name_property: true
    property :subnet, [String, Array, nil], coerce: proc { |v| coerce_subnet(v) }

    alias aux_address auxiliary_addresses

    load_current_value do
      begin
        with_retries { network Docker::Network.get(network_name, {}, connection) }
      rescue Docker::Error::NotFoundError
        current_value_does_not_exist!
      end

      aux_addr_ray = []
      gateway_ray = []
      ip_range_ray = []
      subnet_ray = []

      network.info['IPAM']['Config'].to_a.each do |conf|
        conf.each do |key, value|
          case key
          when 'AuxiliaryAddresses'
            aux_addr_ray << value
          when 'Gateway'
            gateway_ray << value
          when 'IPRange'
            ip_range_ray << value
          when 'Subnet'
            subnet_ray << value
          end
        end
      end

      auxiliary_addresses aux_addr_ray
      gateway gateway_ray
      ip_range ip_range_ray
      subnet subnet_ray

      driver network.info['Driver']
      driver_opts network.info['Options']
    end

    action :create do
      converge_if_changed do
        action_delete

        with_retries do
          options = {}
          options['Driver'] = driver if driver
          options['Options'] = driver_opts if driver_opts
          ipam_options = consolidate_ipam(subnet, ip_range, gateway, aux_address)
          options['IPAM'] = { 'Config' => ipam_options } unless ipam_options.empty?
          options['IPAM']['Driver'] = ipam_driver if ipam_driver
          Docker::Network.create(network_name, options)
        end
      end
    end

    action :delete do
      return unless current_resource
      converge_by "deleting #{network_name}" do
        with_retries do
          network.delete
        end
      end
    end

    action :remove do
      action_delete
    end

    action :connect do
      unless container
        raise Chef::Exceptions::ValidationFailed, 'Container id or name is required for action :connect'
      end

      if current_resource
        container_index = network.info['Containers'].values.index { |c| c['Name'] == container }
        if container_index.nil?
          converge_by("connect #{container}") do
            with_retries do
              network.connect(container)
            end
          end
        end
      else
        Chef::Log.warn("Cannot connect to #{network_name}: network does not exist")
      end
    end

    action :disconnect do
      unless container
        raise Chef::Exceptions::ValidationFailed, 'Container id or name is required for action :disconnect'
      end

      if current_resource
        container_index = network.info['Containers'].values.index { |c| c['Name'] == container }
        unless container_index.nil?
          converge_by("disconnect #{container}") do
            with_retries do
              network.disconnect(container)
            end
          end
        end
      else
        Chef::Log.warn("Cannot disconnect from #{network_name}: network does not exist")
      end
    end
  end
end
