module DockerCookbook
  class DockerServiceManagerSystemd < DockerServiceBase
    resource_name :docker_service_manager_systemd

    provides :docker_service_manager, platform: 'fedora'

    provides :docker_service_manager, platform: %w(redhat centos scientific oracle) do |node| # ~FC005
      node['platform_version'].to_f >= 7.0
    end

    provides :docker_service_manager, platform: 'debian' do |node|
      node['platform_version'].to_f >= 8.0
    end

    provides :docker_service_manager, platform: 'ubuntu' do |node|
      node['platform_version'].to_f >= 15.04
    end

    action :start do
      create_docker_wait_ready

      # stock systemd unit file
      template "/lib/systemd/system/#{docker_name}.service" do
        source 'systemd/docker.service.erb'
        owner 'root'
        group 'root'
        mode '0644'
        variables(
          docker_name: docker_name,
          docker_socket: connect_socket.sub(%r{unix://|fd://}, ''),
          docker_mount_flags: mount_flags
        )
        cookbook 'docker'
        action :create
        not_if { docker_name == 'default' && ::File.exist?('/lib/systemd/system/docker.service') }
      end

      # stock systemd socket file
      template "/lib/systemd/system/#{docker_name}.socket" do
        source 'systemd/docker.socket.erb'
        owner 'root'
        group 'root'
        mode '0644'
        variables(
          docker_name: docker_name,
          docker_socket: connect_socket.sub(%r{unix://|fd://}, '')
        )
        cookbook 'docker'
        action :create
        not_if { docker_name == 'default' && ::File.exist?('/lib/systemd/system/docker.socket') }
      end

      template "/etc/systemd/system/#{docker_name}.service" do
        source 'systemd/docker.service-override.erb'
        owner 'root'
        group 'root'
        mode '0644'
        variables(
          config: new_resource,
          docker_daemon_cmd: docker_daemon_cmd,
          systemd_args: systemd_args,
          docker_wait_ready: "#{libexec_dir}/#{docker_name}-wait-ready",
          docker_mount_flags: mount_flags
        )
        cookbook 'docker'
        notifies :run, 'execute[systemctl daemon-reload]', :immediately
        action :create
      end

      # this overrides the main systemd socket
      template "/etc/systemd/system/#{docker_name}.socket" do
        source 'systemd/docker.socket-override.erb'
        owner 'root'
        group 'root'
        mode '0644'
        variables(
          config: new_resource,
          docker_name: docker_name,
          docker_socket: connect_socket.sub(%r{unix://|fd://}, '')
        )
        cookbook 'docker'
        notifies :run, 'execute[systemctl daemon-reload]', :immediately
        action :create
      end

      # avoid 'Unit file changed on disk' warning
      execute 'systemctl daemon-reload' do
        command '/bin/systemctl daemon-reload'
        action :nothing
      end

      # service management resource
      service docker_name do
        provider Chef::Provider::Service::Systemd
        supports status: true
        action [:enable, :start]
        only_if { ::File.exist?("/lib/systemd/system/#{docker_name}.service") }
      end
    end

    action :stop do
      # service management resource
      service docker_name do
        provider Chef::Provider::Service::Systemd
        supports status: true
        action [:disable, :stop]
        only_if { ::File.exist?("/lib/systemd/system/#{docker_name}.service") }
      end
    end

    action :restart do
      action_stop
      action_start
    end
  end
end
