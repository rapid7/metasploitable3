if defined?(ChefSpec)
  #####################
  # docker_installation
  #####################
  ChefSpec.define_matcher :docker_installation

  def create_docker_installation(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_installation, :create, resource_name)
  end

  def delete_docker_installation(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_installation, :delete, resource_name)
  end

  def create_docker_installation_binary(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_installation_binary, :create, resource_name)
  end

  def delete_docker_installation_binary(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_installation_binary, :delete, resource_name)
  end

  def create_docker_installation_script(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_installation_script, :create, resource_name)
  end

  def delete_docker_installation_script(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_installation_script, :delete, resource_name)
  end

  def create_docker_installation_package(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_installation_package, :create, resource_name)
  end

  def delete_docker_installation_package(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_installation_package, :delete, resource_name)
  end

  def create_docker_installation_tarball(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_installation_tarball, :create, resource_name)
  end

  def delete_docker_installation_tarball(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_installation_tarball, :delete, resource_name)
  end

  ################
  # docker_service
  ################
  ChefSpec.define_matcher :docker_service

  def create_docker_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service, :create, resource_name)
  end

  def delete_docker_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service, :delete, resource_name)
  end

  def start_docker_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service, :start, resource_name)
  end

  def stop_docker_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service, :stop, resource_name)
  end

  def restart_docker_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service, :restart, resource_name)
  end

  ########################
  # docker_service_manager
  ########################
  ChefSpec.define_matcher :docker_service_manager

  def create_docker_service_manager(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager, :create, resource_name)
  end

  def delete_docker_service_manager(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager, :delete, resource_name)
  end

  def start_docker_service_manager(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager, :start, resource_name)
  end

  def stop_docker_service_manager(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager, :stop, resource_name)
  end

  def restart_docker_service_manager(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager, :restart, resource_name)
  end

  def create_docker_service_manager_execute(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager_execute, :create, resource_name)
  end

  def delete_docker_service_manager_execute(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager_execute, :delete, resource_name)
  end

  def start_docker_service_manager_execute(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager_execute, :start, resource_name)
  end

  def stop_docker_service_manager_execute(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager_execute, :stop, resource_name)
  end

  def restart_docker_service_manager_execute(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager_execute, :restart, resource_name)
  end

  def create_docker_service_manager_sysvinit(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager_sysvinit, :create, resource_name)
  end

  def delete_docker_service_manager_sysvinit(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager_sysvinit, :delete, resource_name)
  end

  def start_docker_service_manager_sysvinit(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager_sysvinit, :start, resource_name)
  end

  def stop_docker_service_manager_sysvinit(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager_sysvinit, :stop, resource_name)
  end

  def restart_docker_service_manager_sysvinit(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager_sysvinit, :restart, resource_name)
  end

  def create_docker_service_manager_upstart(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager_upstart, :create, resource_name)
  end

  def delete_docker_service_manager_upstart(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager_upstart, :delete, resource_name)
  end

  def start_docker_service_manager_upstart(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager_upstart, :start, resource_name)
  end

  def stop_docker_service_manager_upstart(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager_upstart, :stop, resource_name)
  end

  def restart_docker_service_manager_upstart(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager_upstart, :restart, resource_name)
  end

  def create_docker_service_manager_systemd(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager_systemd, :create, resource_name)
  end

  def delete_docker_service_manager_systemd(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager_systemd, :delete, resource_name)
  end

  def start_docker_service_manager_systemd(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager_systemd, :start, resource_name)
  end

  def stop_docker_service_manager_systemd(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager_systemd, :stop, resource_name)
  end

  def restart_docker_service_manager_systemd(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_service_manager_systemd, :restart, resource_name)
  end

  ##############
  # docker_image
  ##############
  ChefSpec.define_matcher :docker_image

  def build_docker_image(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_image, :build, resource_name)
  end

  def build_if_missing_docker_image(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_image, :build_if_missing, resource_name)
  end

  def pull_docker_image(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_image, :pull, resource_name)
  end

  def pull_if_missing_docker_image(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_image, :pull_if_missing, resource_name)
  end

  def import_docker_image(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_image, :import, resource_name)
  end

  def push_docker_image(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_image, :push, resource_name)
  end

  def remove_docker_image(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_image, :remove, resource_name)
  end

  def save_docker_image(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_image, :save, resource_name)
  end

  def load_docker_image(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_image, :load, resource_name)
  end

  ##################
  # docker_container
  ##################
  ChefSpec.define_matcher :docker_container

  def create_docker_container(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_container, :create, resource_name)
  end

  def start_docker_container(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_container, :start, resource_name)
  end

  def stop_docker_container(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_container, :stop, resource_name)
  end

  def kill_docker_container(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_container, :kill, resource_name)
  end

  def run_docker_container(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_container, :run, resource_name)
  end

  def run_if_missing_docker_container(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_container, :run_if_missing, resource_name)
  end

  def pause_docker_container(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_container, :pause, resource_name)
  end

  def unpause_docker_container(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_container, :unpause, resource_name)
  end

  def restart_docker_container(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_container, :restart, resource_name)
  end

  def redeploy_docker_container(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_container, :redeploy, resource_name)
  end

  def delete_docker_container(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_container, :delete, resource_name)
  end

  def remove_docker_container(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_container, :remove, resource_name)
  end

  def commit_docker_container(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_container, :commit, resource_name)
  end

  def export_docker_container(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_container, :export, resource_name)
  end

  ##############
  # docker_tag
  ##############
  ChefSpec.define_matcher :docker_tag

  def tag_docker_tag(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_tag, :tag, resource_name)
  end

  #################
  # docker_registry
  #################
  ChefSpec.define_matcher :docker_registry

  def login_docker_registry(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_registry, :login, resource_name)
  end

  ################
  # docker_network
  ################
  ChefSpec.define_matcher :docker_network

  def create_docker_network(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_network, :create, resource_name)
  end

  def delete_docker_network(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_network, :delete, resource_name)
  end

  def connect_docker_network(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_network, :connect, resource_name)
  end

  def disconnect_docker_network(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_network, :disconnect, resource_name)
  end

  ###############
  # docker_volume
  ###############
  ChefSpec.define_matcher :docker_volume

  def create_docker_volume(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_volume, :create, resource_name)
  end

  def remove_docker_volume(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_volume, :remove, resource_name)
  end

  ###############
  # docker_exec
  ###############
  ChefSpec.define_matcher :docker_exec

  def run_docker_exec(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:docker_exec, :run, resource_name)
  end
end
