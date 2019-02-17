module DockerCookbook
  class DockerServiceManagerUpstart < DockerServiceBase
    resource_name :docker_service_manager_upstart

    provides :docker_service_manager, platform_family: 'debian' do |_node|
      Chef::Platform::ServiceHelpers.service_resource_providers.include?(:upstart) &&
        !Chef::Platform::ServiceHelpers.service_resource_providers.include?(:systemd)
    end

    action :start do
      create_docker_wait_ready

      link dockerd_bin_link do
        to dockerd_bin
        link_type :hard
        action :create
      end

      template "/etc/init/#{docker_name}.conf" do
        source 'upstart/docker.conf.erb'
        cookbook 'docker'
        owner 'root'
        group 'root'
        mode '0644'
        variables(
          docker_daemon_cmd: [dockerd_bin_link, docker_daemon_arg, docker_daemon_opts].join(' '),
          docker_raw_logs_arg: docker_raw_logs_arg,
          docker_wait_ready: "#{libexec_dir}/#{docker_name}-wait-ready",
          docker_socket: connect_socket
        )
        notifies :stop, "service[#{docker_name}]", :immediately
        notifies :start, "service[#{docker_name}]", :immediately
      end

      template "/etc/default/#{docker_name}" do
        source 'default/docker.erb'
        cookbook 'docker'
        variables(config: new_resource)
        notifies :restart, "service[#{docker_name}]", :immediately
      end

      service docker_name do
        provider Chef::Provider::Service::Upstart
        supports status: true, restart: false
        action :start
      end
    end

    action :stop do
      service docker_name do
        provider Chef::Provider::Service::Upstart
        supports status: true, restart: false
        action :stop
      end
    end

    action :restart do
      action_stop
      action_start
    end
  end
end
