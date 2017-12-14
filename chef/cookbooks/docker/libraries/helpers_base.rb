module DockerCookbook
  module DockerHelpers
    module Base
      require 'shellwords'

      # Misc
      def to_snake_case(name)
        # ExposedPorts -> _exposed_ports
        name = name.gsub(/[A-Z]/) { |x| "_#{x.downcase}" }
        # _exposed_ports -> exposed_ports
        name = name[1..-1] if name.start_with?('_')
        name
      end

      ##########
      # coersion
      ##########

      def coerce_labels(v)
        case v
        when Hash, nil
          v
        else
          Array(v).each_with_object({}) do |label, h|
            parts = label.split(':')
            h[parts[0]] = parts[1]
          end
        end
      end

      def coerce_shell_command(v)
        return nil if v.nil?
        return DockerBase::ShellCommandString.new(
          ::Shellwords.join(v)
        ) if v.is_a?(Array)
        DockerBase::ShellCommandString.new(v)
      end

      ################
      # Helper methods
      ################

      def api_version
        @api_version ||= Docker.version(connection)['ApiVersion']
      end

      def connection
        @connection ||= begin
                          opts = {}
                          opts[:read_timeout] = read_timeout if read_timeout
                          opts[:write_timeout] = write_timeout if write_timeout

                          if host =~ /^tcp:/
                            opts[:scheme] = 'https' if tls || !tls_verify.nil?
                            opts[:ssl_ca_file] = tls_ca_cert if tls_ca_cert
                            opts[:client_cert] = tls_client_cert if tls_client_cert
                            opts[:client_key] = tls_client_key if tls_client_key
                          end
                          Docker::Connection.new(host || Docker.url, opts)
                        end
      end

      def with_retries(&_block)
        tries = api_retries
        begin
          yield
          # Only catch errors that can be fixed with retries.
        rescue Docker::Error::ServerError, # 404
               Docker::Error::UnexpectedResponseError, # 400
               Docker::Error::TimeoutError,
               Docker::Error::IOError
          tries -= 1
          retry if tries > 0
          raise
        end
      end

      def call_action(_action)
        new_resource.run_action
      end

      def default_host
        return nil unless ENV['DOCKER_HOST']
        ENV['DOCKER_HOST']
      end

      def default_tls
        return nil unless ENV['DOCKER_TLS']
        ENV['DOCKER_TLS']
      end

      def default_tls_verify
        return nil unless ENV['DOCKER_TLS_VERIFY']
        ENV['DOCKER_TLS_VERIFY']
      end

      def default_tls_cert_path(v)
        return nil unless ENV['DOCKER_CERT_PATH']
        case v
        when 'ca'
          "#{ENV['DOCKER_CERT_PATH']}/ca.pem"
        when 'cert'
          "#{ENV['DOCKER_CERT_PATH']}/cert.pem"
        when 'key'
          "#{ENV['DOCKER_CERT_PATH']}/key.pem"
        end
      end
    end
  end
end
