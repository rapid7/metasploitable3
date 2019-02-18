module DockerCookbook
  class DockerTag < DockerBase
    resource_name :docker_tag

    property :target_repo, String, name_property: true
    property :target_tag, String
    property :to_repo, String
    property :to_tag, String
    property :force, [TrueClass, FalseClass], default: false, desired_state: false

    #########
    # Actions
    #########

    action :tag do
      return if new_resource.force == false && Docker::Image.exist?("#{new_resource.to_repo}:#{new_resource.to_tag}")
      begin
        converge_by "update #{new_resource.target_repo}:#{new_resource.target_tag} to #{new_resource.to_repo}:#{new_resource.to_tag}" do
          i = Docker::Image.get("#{new_resource.target_repo}:#{new_resource.target_tag}")
          i.tag('repo' => new_resource.to_repo, 'tag' => new_resource.to_tag, 'force' => new_resource.force)
        end
      rescue Docker::Error => e
        raise e.message
      end
    end
  end
end
