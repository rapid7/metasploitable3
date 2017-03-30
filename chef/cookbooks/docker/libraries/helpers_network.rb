module DockerCookbook
  module DockerHelpers
    module Network
      require 'ipaddr'

      ###################
      # property coersion
      ###################

      def coerce_auxiliary_addresses(v)
        ray = []
        Array(v).each do |e|
          case e
          when String, Array, nil
            ray += Array(e)
          when Hash
            e.each { |key, val| ray << "#{key}=#{val}" }
          end
        end
        ray.length == 1 ? ray[0] : ray
      end

      def coerce_gateway(v)
        case v
        when String
          v.split('/')[0]
        when Array
          ray = Array(v).map { |a| a.split('/')[0] }
          ray.length == 1 ? ray[0] : ray
        end
      end

      def coerce_subnet(v)
        Array(v).length == 1 ? Array(v)[0] : v
      end

      def coerce_ip_range(v)
        Array(v).length == 1 ? Array(v)[0] : v
      end

      ######
      # IPAM
      ######

      def consolidate_ipam(subnets, ranges, gateways, auxaddrs)
        subnets = Array(subnets)
        ranges = Array(ranges)
        gateways = Array(gateways)
        auxaddrs = Array(auxaddrs)
        subnets = [] if subnets.empty?
        ranges = [] if ranges.empty?
        gateways = [] if gateways.empty?
        auxaddrs = [] if auxaddrs.empty?
        if subnets.size < ranges.size || subnets.size < gateways.size
          raise 'every ip-range or gateway myust have a corresponding subnet'
        end

        data = {}

        # Check overlapping subnets
        subnets.each do |s|
          data.each do |k, _|
            if subnet_matches(s, k) || subnet_matches(k, s)
              raise 'multiple overlapping subnet configuration is not supported'
            end
          end
          data[s] = { 'Subnet' => s, 'AuxiliaryAddresses' => {} }
        end

        ranges.each do |r|
          match = false
          subnets.each do |s|
            ok = subnet_matches(s, r)
            next unless ok
            if data[s].fetch('IPRange', '') != ''
              raise 'cannot configure multiple ranges on the same subnet'
            end
            data[s]['IPRange'] = r
            match = true
          end
          raise "no matching subnet for range #{r}" unless match
        end

        gateways.each do |g|
          match = false
          subnets.each do |s|
            ok = subnet_matches(s, g)
            next unless ok
            unless data[s].fetch('Gateway', '').empty?
              raise "cannot configure multiple gateways (#{g}, #{data[s]['Gateway']}) for the same subnet (#{s})"
            end
            data[s]['Gateway'] = g
            match = true
          end
          raise "no matching subnet for gateway #{s}" unless match
        end

        auxaddrs.each do |aa|
          key, a = aa.split('=')
          match = false
          subnets.each do |s|
            # require 'pry' ; binding.pry
            ok = subnet_matches(s, a)
            next unless ok
            data[s]['AuxiliaryAddresses'][key] = a
            match = true
          end
          raise "no matching subnet for aux-address #{a}" unless match
        end
        data.values
      end

      def subnet_matches(subnet, data)
        IPAddr.new(subnet).include?(IPAddr.new(data))
      end
    end
  end
end
