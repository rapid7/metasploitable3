module DockerCookbook
  module DockerHelpers
    module Image
      ################
      # Helper methods
      ################

      def build_from_directory
        i = Docker::Image.build_from_dir(
          source,
          {
            'nocache' => nocache,
            'rm' => rm,
          },
          connection
        )
        i.tag('repo' => repo, 'tag' => tag, 'force' => force)
      end

      def build_from_dockerfile
        i = Docker::Image.build(
          IO.read(source),
          {
            'nocache' => nocache,
            'rm' => rm,
          },
          connection
        )
        i.tag('repo' => repo, 'tag' => tag, 'force' => force)
      end

      def build_from_tar
        i = Docker::Image.build_from_tar(
          ::File.open(source, 'r'),
          {
            'nocache' => nocache,
            'rm' => rm,
          },
          connection
        )
        i.tag('repo' => repo, 'tag' => tag, 'force' => force)
      end

      def build_image
        if ::File.directory?(source)
          build_from_directory
        elsif ::File.extname(source) == '.tar'
          build_from_tar
        else
          build_from_dockerfile
        end
      end

      def image_identifier
        "#{repo}:#{tag}"
      end

      def import_image
        with_retries do
          i = Docker::Image.import(source, {}, connection)
          i.tag('repo' => repo, 'tag' => tag, 'force' => force)
        end
      end

      def pull_image
        with_retries do
          registry_host = parse_registry_host(repo)
          creds = node.run_state['docker_auth'] && node.run_state['docker_auth'][registry_host] || (node.run_state['docker_auth'] ||= {})['index.docker.io']

          original_image = Docker::Image.get(image_identifier, {}, connection) if Docker::Image.exist?(image_identifier, {}, connection)
          new_image = Docker::Image.create({ 'fromImage' => image_identifier }, creds, connection)

          !(original_image && original_image.id.start_with?(new_image.id))
        end
      end

      def push_image
        with_retries do
          i = Docker::Image.get(image_identifier, {}, connection)
          i.push
        end
      end

      def remove_image
        with_retries do
          i = Docker::Image.get(image_identifier, {}, connection)
          i.remove(force: force, noprune: noprune)
        end
      end

      def save_image
        with_retries do
          Docker::Image.save(repo, destination, connection)
        end
      end

      def load_image
        with_retries do
          Docker::Image.load(source, {}, connection)
        end
      end
    end
  end
end
