module DockerCookbook
  class DockerServiceManagerSysvinitRhel < DockerServiceBase
    resource_name :docker_service_manager_sysvinit_rhel

    provides :docker_service_manager, platform: 'amazon'
    provides :docker_service_manager, platform: 'suse'
    provides :docker_service_manager, platform_family: 'rhel' do |node|
      node['platform_version'].to_f <= 7.0
    end

    provides :docker_service_manager_sysvinit, platform: 'amazon'
    provides :docker_service_manager_sysvinit, platform: 'suse'
    provides :docker_service_manager_sysvinit, platform_family: 'rhel' do |node|
      node['platform_version'].to_f <= 7.0
    end

    action :start do
      create_docker_wait_ready
      create_init
      create_service
    end

    action :stop do
      create_init
      s = create_service
      s.action :stop
    end

    action :restart do
      action_stop
      action_start
    end

    action_class.class_eval do
      def create_init
        execute 'groupadd docker' do
          not_if 'getent group docker'
          action :run
        end

        link dockerd_bin_link do
          to dockerd_bin
          link_type :hard
        end

        template "/etc/init.d/#{docker_name}" do
          cookbook 'docker'
          source 'sysvinit/docker-rhel.erb'
          owner 'root'
          group 'root'
          mode '0755'
          variables(
            docker_name: docker_name,
            dockerd_bin_link: dockerd_bin_link,
            docker_daemon_cmd: docker_daemon_cmd,
            docker_wait_ready: "#{libexec_dir}/#{docker_name}-wait-ready"
          )
          notifies :restart, "service[#{docker_name}]", :immediately
        end

        template "/etc/sysconfig/#{docker_name}" do
          cookbook 'docker'
          source 'sysconfig/docker.erb'
          owner 'root'
          group 'root'
          mode '0644'
          variables(config: new_resource)
          notifies :restart, "service[#{docker_name}]", :immediately
        end
      end

      def create_service
        service docker_name do
          supports restart: true, status: true
          action [:enable, :start]
        end
      end
    end
  end
end
