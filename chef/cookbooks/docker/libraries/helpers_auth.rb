module DockerCookbook
  module DockerHelpers
    module Authentication
      # https://github.com/docker/docker/blob/4fcb9ac40ce33c4d6e08d5669af6be5e076e2574/registry/auth.go#L231
      def parse_registry_host(val)
        val.sub(%r{https?://}, '').split('/').first
      end
    end
  end
end
