if defined?(ChefSpec)
  ChefSpec.define_matcher :mysql_config
  ChefSpec.define_matcher :mysql_service
  ChefSpec.define_matcher :mysql_client

  # mysql_client_client_installation_package
  def install_mysql_client_installation_package(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:mysql_client_installation_package, :create, resource_name)
  end

  def remove_mysql_client_installation_package(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:mysql_client_installation_package, :remove, resource_name)
  end

  # mysql_server_server_installation_package
  def install_mysql_server_installation_package(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:mysql_server_installation_package, :install, resource_name)
  end

  def remove_mysql_server_installation_package(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:mysql_server_installation_package, :remove, resource_name)
  end

  #####
  # old
  #####

  # client
  def create_mysql_client(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:mysql_client, :create, resource_name)
  end

  def delete_mysql_client(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:mysql_client, :delete, resource_name)
  end

  # mysql_config
  def create_mysql_config(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:mysql_config, :create, resource_name)
  end

  def delete_mysql_config(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:mysql_config, :delete, resource_name)
  end

  # service
  def create_mysql_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:mysql_service, :create, resource_name)
  end

  def delete_mysql_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:mysql_service, :delete, resource_name)
  end

  def start_mysql_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:mysql_service, :start, resource_name)
  end

  def stop_mysql_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:mysql_service, :stop, resource_name)
  end

  def restart_mysql_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:mysql_service, :restart, resource_name)
  end

  def reload_mysql_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:mysql_service, :reload, resource_name)
  end

end
