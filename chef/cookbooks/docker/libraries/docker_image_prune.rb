module DockerCookbook
  class DockerImagePrune < DockerBase
    resource_name :docker_image_prune
    # Requires docker API v1.25
    # Modify the default of read_timeout from 60 to 120
    property :read_timeout, default: 120, desired_state: false
    property :host, [String, nil], default: lazy { ENV['DOCKER_HOST'] }, desired_state: false

    # https://docs.docker.com/engine/api/v1.35/#operation/ImagePrune
    property :dangling, [TrueClass, FalseClass], default: true
    property :prune_until, String
    # https://docs.docker.com/engine/reference/builder/#label
    property :with_label, String
    property :without_label, String

    #########
    # Actions
    #########

    default_action :prune

    action :prune do
      # Have to call this method ourselves due to
      # https://github.com/swipely/docker-api/pull/507
      json = generate_json(new_resource)
      # Post
      res = connection.post('/images/prune', json)
      Chef::Log.info res
    end

    def generate_json(new_resource)
      opts = { filters: ["dangling=#{new_resource.dangling}"] }
      opts[:filters].push("until=#{new_resource.prune_until}") if new_resource.property_is_set?(:prune_until)
      opts[:filters].push("label=#{new_resource.with_label}") if new_resource.property_is_set?(:with_label)
      opts[:filters].push("label!=#{new_resource.without_label}") if new_resource.property_is_set?(:without_label)
      opts.to_json
    end
  end
end
