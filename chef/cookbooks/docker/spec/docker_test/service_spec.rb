require 'spec_helper'
require_relative '../../libraries/helpers_service'

describe 'docker_test::service' do
  before do
    allow_any_instance_of(DockerCookbook::DockerHelpers::Service).to receive(:installed_docker_version).and_return('18.06.0')
  end

  cached(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu',
                             version: '16.04',
                             step_into: %w(helpers_service docker_service docker_service_base docker_service_manager docker_service_manager_systemd)).converge(described_recipe)
  end

  # If you have to change this file you most likely updated a default service option
  # Please note that it will require a docker service restart
  # Which is consumer impacting
  expected = <<EOH
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target docker.socket firewalld.service
Requires=docker.socket
Wants=network-online.target

[Service]
Type=notify
ExecStartPre=/sbin/sysctl -w net.ipv4.ip_forward=1
ExecStartPre=/sbin/sysctl -w net.ipv6.conf.all.forwarding=1
ExecStart=/usr/bin/dockerd  --bip=10.10.10.0/24 --group=docker --default-address-pool=base=10.10.10.0/16,size=24 --pidfile=/var/run/docker.pid --storage-driver=overlay2
ExecStartPost=/usr/lib/docker/docker-wait-ready
ExecReload=/bin/kill -s HUP $MAINPID
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity
TasksMax=infinity
TimeoutStartSec=0
Delegate=yes
KillMode=process
Restart=always
StartLimitBurst=3
StartLimitInterval=60s


[Install]
WantedBy=multi-user.target
EOH

  it 'creates docker_service[default]' do
    expect(chef_run).to render_file('/etc/systemd/system/docker.service').with_content { |content|
      # For tests which run on windows - convert CRLF
      expect(content.gsub(/[\r\n]+/m, "\n")).to match(expected.gsub(/[\r\n]+/m, "\n"))
    }
  end
end
