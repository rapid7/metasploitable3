module DockerCookbook
  class DockerTag < DockerBase
    resource_name :docker_tag

    property :target_repo, String, name_property: true
    property :target_tag, String
    property :to_repo, String
    property :to_tag, String
    property :force, Boolean, default: false

    #########
    # Actions
    #########

    action :tag do
      return if force == false && Docker::Image.exist?("#{to_repo}:#{to_tag}")
      begin
        converge_by "update #{target_repo}:#{target_tag} to #{to_repo}:#{to_tag}" do
          i = Docker::Image.get("#{target_repo}:#{target_tag}")
          i.tag('repo' => to_repo, 'tag' => to_tag, 'force' => force)
        end
      rescue Docker::Error => e
        raise e.message
      end
    end
  end
end
