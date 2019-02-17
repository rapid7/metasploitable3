module DockerCookbook
  class DockerPlugin < DockerBase
    resource_name :docker_plugin

    property :local_alias, String, name_property: true
    property :remote_tag, String, default: 'latest'
    property :remote, [String, nil], default: nil
    property :grant_privileges, [Array, TrueClass], default: []
    property :options, Hash, default: {}

    default_action :install

    action :install do
      return if plugin_exists?(local_name)
      converge_by "Install plugin #{plugin_identifier} as #{local_name}" do
        install_plugin
        configure_plugin
      end
    end

    action :enable do
      converge_by "Enable plugin #{local_name}" do
        enable_plugin
      end unless plugin_enabled?(local_name)
    end

    action :disable do
      converge_by "Disable plugin #{local_name}" do
        disable_plugin
      end if plugin_enabled?(local_name)
    end

    action :update do
      converge_by "Configure plugin #{local_name}" do
        configure_plugin
      end
    end

    action :remove do
      converge_by "Remove plugin #{local_name}" do
        remove_plugin
      end
    end

    declare_action_class.class_eval do
      def remote_name
        return new_resource.remote unless new_resource.remote.nil? || new_resource.remote.empty?
        new_resource.local_alias
      end

      def plugin_identifier
        "#{remote_name}:#{new_resource.remote_tag}"
      end

      def local_name
        new_resource.local_alias
      end

      def plugin_exists?(name)
        Docker.connection.get("/plugins/#{name}/json")
        true
      rescue Docker::Error::NotFoundError
        false
      end

      def plugin_enabled?(name)
        JSON.parse(Docker.connection.get("/plugins/#{name}/json"))['Enabled']
      end

      def install_plugin
        privileges = \
          if new_resource.grant_privileges == true
            # user gave a blanket statement about privileges; fetch required privileges from Docker
            # we pass the identifier as both :name and :remote to accomodate different API versions
            JSON.parse Docker.connection.get('/plugins/privileges',
                                             name: plugin_identifier,
                                             remote: plugin_identifier)
          else
            # user gave a specific list of privileges
            new_resource.grant_privileges
          end

        # actually do the plugin install
        body = ''

        opts = { remote: plugin_identifier, name: local_name }
        Chef::Log.info("pulling plugin #{opts} with privileges #{privileges}")
        Docker.connection.post('/plugins/pull', opts,
                               body: JSON.generate(privileges),
                               response_block: response_block(body))

        last_line = body.split("\n").select { |item| !item.empty? }.last
        info = JSON.parse last_line
        raise info['error'] if info.key?('error')
      end

      def response_block(body)
        lambda do |chunk, _remaining, _total|
          body << chunk
        end
      end

      def configure_plugin
        options_for_json = []
        new_resource.options.each_pair do |k, v|
          options_for_json.push("#{k}=#{v}")
        end

        Docker.connection.post("/plugins/#{local_name}/set", {}, body: JSON.generate(options_for_json))
      end

      def enable_plugin
        Docker.connection.post("/plugins/#{local_name}/enable", timeout: new_resource.read_timeout)
      end

      def disable_plugin
        Docker.connection.post("/plugins/#{local_name}/disable", timeout: new_resource.read_timeout)
      end

      def remove_plugin
        Docker.connection.delete("/plugins/#{local_name}")
      end
    end
  end
end
