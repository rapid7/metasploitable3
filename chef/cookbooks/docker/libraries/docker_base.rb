module DockerCookbook
  class DockerBase < Chef::Resource
    require_relative 'helpers_auth'
    require_relative 'helpers_base'

    include DockerHelpers::Base

    #########
    # Classes
    #########

    class UnorderedArray < Array
      def ==(other)
        # If I (desired env) am a subset of the current env, let == return true
        other.is_a?(Array) && all? { |val| other.include?(val) }
      end
    end

    class ShellCommandString < String
      def ==(other)
        other.is_a?(String) && Shellwords.shellwords(self) == Shellwords.shellwords(other)
      end
    end

    class PartialHash < Hash
      def ==(other)
        other.is_a?(Hash) && all? { |key, val| other.key?(key) && other[key] == val }
      end
    end

    ################
    # Type Constants
    #
    # These will be used when declaring resource property types in the
    # docker_service, docker_container, and docker_image resource.
    #
    ################

    ArrayType = property_type(
      is: [Array, nil],
      coerce: proc { |v| v.nil? ? nil : Array(v) }
    ) unless defined?(ArrayType)

    Boolean = property_type(
      is: [true, false],
      default: false
    ) unless defined?(Boolean)

    NonEmptyArray = property_type(
      is: [Array, nil],
      coerce: proc { |v| Array(v).empty? ? nil : Array(v) }
    ) unless defined?(NonEmptyArray)

    ShellCommand = property_type(
      is: [String],
      coerce: proc { |v| coerce_shell_command(v) }
    ) unless defined?(ShellCommand)

    UnorderedArrayType = property_type(
      is: [UnorderedArray, nil],
      coerce: proc { |v| v.nil? ? nil : UnorderedArray.new(Array(v)) }
    ) unless defined?(UnorderedArrayType)

    PartialHashType = property_type(
      is: [PartialHash, nil],
      coerce: proc { |v| v.nil? ? nil : PartialHash[v] }
    ) unless defined?(PartialHashType)

    #####################
    # Resource properties
    #####################

    property :api_retries, Integer, default: 3, desired_state: false
    property :read_timeout, [Integer, nil], default: 60, desired_state: false
    property :write_timeout, [Integer, nil], desired_state: false
    property :running_wait_time, [Integer, nil], default: 20, desired_state: false

    property :tls, [Boolean, nil], default: lazy { default_tls }, desired_state: false
    property :tls_verify, [Boolean, nil], default: lazy { default_tls_verify }, desired_state: false
    property :tls_ca_cert, [String, nil], default: lazy { default_tls_cert_path('ca') }, desired_state: false
    property :tls_server_cert, [String, nil], desired_state: false
    property :tls_server_key, [String, nil], desired_state: false
    property :tls_client_cert, [String, nil], default: lazy { default_tls_cert_path('cert') }, desired_state: false
    property :tls_client_key, [String, nil], default: lazy { default_tls_cert_path('key') }, desired_state: false

    declare_action_class.class_eval do
      include DockerHelpers::Authentication
    end
  end
end
