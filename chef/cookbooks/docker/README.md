# Docker Cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/docker.svg?branch=master)](https://travis-ci.org/chef-cookbooks/docker) [![Cookbook Version](https://img.shields.io/cookbook/v/docker.svg)](https://supermarket.chef.io/cookbooks/docker)

The Docker Cookbook provides resources for installing docker as well as building, managing, and running docker containers.

## Scope

This cookbook is concerned with the [Docker](http://docker.io) container engine as distributed by Docker, Inc. It does not address Docker ecosystem tooling or prerequisite technology such as cgroups or aufs.

## Requirements

- Chef 12.15 or later
- Network accessible web server hosting the docker binary.
- SELinux permissive/disabled if CentOS [Docker Issue #15498](https://github.com/docker/docker/issues/15498)

## Platform Support

- Amazon Linux
- Debian 8/9
- Fedora
- Ubuntu 14.04/16.04
- CentOS 7

## Cookbook Dependencies

This cookbook automatically sets up the upstream Docker package repositories. If you would like to use your own repositories this functionality can be disabled and you can instead setup the repos yourself with yum_repository/apt_repository resources or the [chef-apt-docker](https://supermarket.chef.io/cookbooks/chef-apt-docker) / [chef-yum-docker](https://supermarket.chef.io/cookbooks/chef-yum-docker) cookbooks.

## Docker Group

If you are not using the official docker repositories you may run into issues with the docker group being different. RHEL is a known issue that defaults to using `dockerroot` for the service group. Add the `group` property to the `docker_service`.

```ruby
docker_service 'default' do
  group 'dockerroot'
  action [:create, :start]
end
```

## Usage

- Add `depends 'docker'` to your cookbook's metadata.rb
- Use the resources shipped in cookbook in a recipe, the same way you'd use core Chef resources (file, template, directory, package, etc).

```ruby
docker_service 'default' do
  action [:create, :start]
end

docker_image 'busybox' do
  action :pull
end

docker_container 'an-echo-server' do
  repo 'busybox'
  port '1234:1234'
  command "nc -ll -p 1234 -e /bin/cat"
end
```

## Test Cookbooks as Examples

The cookbooks ran under test-kitchen make excellent usage examples.

The test recipes are found at:

```
test/cookbooks/docker_test/
```

## Resources Overview

- [docker_service](#docker_service): composite resource that uses docker_installation and docker_service_manager
- [docker_installation](#docker_installation): automatically select an installation method
- [docker_service_manager](#docker_service_manager): automatically selects a service manager
- [docker_installation_script](#docker_installation_script): curl | bash
- [docker_installation_package](#docker_installation_package): package 'docker-ce'
- [docker_service_manager_execute](#docker_service_manager_execute): manage docker daemon with Chef
- [docker_service_manager_sysvinit](#docker_service_manager_sysvinit): manage docker daemon with a sysvinit script
- [docker_service_manager_upstart](#docker_service_manager_upstart): manage docker daemon with upstart script
- [docker_service_manager_systemd](#docker_service_manager_systemd): manage docker daemon with systemd unit files
- [docker_image](#docker_image): image/repository operations
- [docker_container](#docker_container): container operations
- [docker_tag](#docker_tag): image tagging operations
- [docker_registry](#docker_registry): registry operations
- [docker_network](#docker_network): network operations
- [docker_volume](#docker_volume): volume operations
- [docker_plugin](#docker_plugin): plugin operations

## Getting Started

Here's a quick example of pulling the latest image and running a container with exposed ports.

```ruby
# Pull latest image
docker_image 'nginx' do
  tag 'latest'
  action :pull
  notifies :redeploy, 'docker_container[my_nginx]'
end

# Run container mapping containers port 80 to the host's port 80
docker_container 'my_nginx' do
  repo 'nginx'
  tag 'latest'
  port '80:80'
  host_name 'www'
  domain_name 'computers.biz'
  env 'FOO=bar'
  volumes [ '/some/local/files/:/etc/nginx/conf.d' ]
end
```

You might run a private registry and multiple Docker hosts.

```ruby
# Login to private registry
docker_registry 'https://registry.computers.biz/' do
  username 'shipper'
  password 'iloveshipping'
  email 'shipper@computers.biz'
end

# Pull tagged image
docker_image 'registry.computers.biz:443/my_project/my_container' do
  tag 'latest'
  action :pull
  host 'tcp://host-1.computers.biz:2376'
end

# Run container
docker_container 'crowsnest' do
  repo 'registry.computers.biz:443/my_project/my_container'
  tag 'latest'
  host 'tcp://host-2.computers.biz:2376'
  tls_verify true
  tls_ca_cert "/path/to/ca.pem"
  tls_client_cert "/path/to/cert.pem"
  tls_client_key "/path/to/key.pem"
  action :run
end
```

You can manipulate Docker volumes and networks

```ruby
docker_network 'my_network' do
  subnet '10.9.8.0/24'
  gateway '10.9.8.1'
end

docker_volume 'my_volume' do
  action :create
end

docker_container 'my_container' do
  repo 'alpine'
  tag '3.1'
  command "nc -ll -p 1234 -e /bin/cat"
  volumes 'my_volume:/my_data'
  network_mode 'my_network'
  action :run
end
```

See full documentation for each resource and action below for more information.

## Resources

## docker_installation

The `docker_installation` resource auto-selects one of the below resources with the provider resolution system.

### Example

```ruby
docker_installation 'default'
```

## docker_installation_tarball

The `docker_installation_tarball` resource copies the precompiled Go binary tarball onto the disk. It should not be used in production, especially with devicemapper.

### Example

```ruby
docker_installation_tarball 'default' do
  version '1.11.0'
  source 'https://my.computers.biz/dist/docker.tgz'
  checksum '97a3f5924b0b831a310efa8bf0a4c91956cd6387c4a8667d27e2b2dd3da67e4d'
  action :create
end
```

### Properties

- `version` - The desired version of docker to fetch.
- `channel` - The docker channel to fetch the tarball from. Default: stable
- `source` - Path to network accessible Docker binary tarball. Ignores version when set.
- `checksum` - SHA-256 checksum of the tarball file.

## docker_installation_script

The `docker_installation_script` resource runs the script hosted by Docker, Inc at <http://get.docker.com>. It configures package repositories and installs a dynamically compiled binary.

### Example

```ruby
docker_installation_script 'default' do
  repo 'main'
  script_url 'https://my.computers.biz/dist/scripts/docker.sh'
  action :create
end
```

### Properties

- `repo` - One of 'main', 'test', or 'experimental'. Used to calculate script_url in its absence. Defaults to 'main'
- `script_url` - 'URL of script to pipe into /bin/sh as root.

## docker_installation_package

The `docker_installation_package` resource uses the system package manager to install Docker. It relies on the pre-configuration of the system's package repositories. The `chef-yum-docker` and `chef-apt-docker` Supermarket cookbooks can be used to use Docker's own repositories.

**_This is the recommended production installation method._**

### Example

```ruby
docker_installation_package 'default' do
  version '1.8.3'
  action :create
  package_options %q|--force-yes -o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-all'| # if Ubuntu for example
end
```

### Properties

- `version` - Used to calculate package_version string
- `package_version` - Manually specify the package version string
- `package_name` - Name of package to install. Defaults to 'docker-ce'
- `package_options` - Manually specify additional options, like apt-get directives for example
- `setup_docker_repo` - Setup the download.docker.com repo. If you would like to manage the repo yourself so you can use an internal repo then set this to false. default: true on all platforms except Amazon Linux.
- `repo_channel` - The channel of docker to setup from download.docker.com. Only used if `setup_docker_repo` is true. default: 'stable'

## docker_service_manager

The `docker_service_manager` resource auto-selects a strategy from the `docker_service_manager_*` group of resources based on platform and version. The `docker_service` family share a common set of properties.

### Example

```ruby
docker_service_manager 'default' do
  action :start
end
```

## docker_service_manager_execute

### Example

```ruby
docker_service_manager_execute 'default' do
  action :start
end
```

## docker_service_manager_sysvinit

### Example

```ruby
docker_service_manager_sysvinit 'default' do
  host 'unix:///var/run/docker.sock'
  action :stop
end
```

## docker_service_manager_upstart

### Example

```ruby
docker_service_manager_upstart 'default' do
  host ['unix:///var/run/docker.sock', 'tcp://127.0.0.1:2376']
  action :start
end
```

## docker_service_manager_systemd

### Example

```ruby
docker_service_manager_systemd 'default' do
  host ['unix:///var/run/docker.sock', 'tcp://127.0.0.1:2376']
  tls_verify true
  tls_ca_cert "/path/to/ca.pem"
  tls_server_cert "/path/to/server.pem"
  tls_server_key "/path/to/server-key.pem"
  tls_client_cert "/path/to/cert.pem"
  tls_client_key "/path/to/key.pem"
  systemd_opts ["TasksMax=infinity","MountFlags=private"]
  systemd_socket_opts ["Accept=yes"]
  action :start
end
```

## docker_service

The `docker_service`: resource is a composite resource that uses `docker_installation` and `docker_service_manager` resources.

- The `:create` action uses a `docker_installation`
- The `:delete` action uses a `docker_installation`
- The `:start` action uses a `docker_service_manager`
- The `:stop` action uses a `docker_service_manager`

The service management strategy for the host platform is dynamically chosen based on platform, but can be overridden.

### Example

```ruby
docker_service 'tls_test:2376' do
  host [ "tcp://#{node['ipaddress']}:2376", 'unix:///var/run/docker.sock' ]
  tls_verify true
  tls_ca_cert '/path/to/ca.pem'
  tls_server_cert '/path/to/server.pem'
  tls_server_key '/path/to/server-key.pem'
  tls_client_cert '/path/to/client.pem'
  tls_client_key '/path/to/client-key.pem'
  action [:create, :start]
end
```

WARNING - When creating multiple `docker_service` resources on the same machine, you will need to specify unique data_root properties to avoid unexpected behavior and possible data corruption.

### Properties

The `docker_service` resource property list mostly corresponds to the options found in the [Docker Command Line Reference](https://docs.docker.com/engine/reference/commandline/docker/)

- `api_cors_header` - Set CORS headers in the remote API
- `auto_restart`
- `exec_opts`
- `bip` - Specify network bridge IP
- `bridge` - Attach containers to a network bridge
- `checksum` - sha256 checksum of Docker binary
- `cluster_advertise` - IP and port that this daemon should advertise to the cluster
- `cluster_store_opts` - Cluster store options
- `cluster_store` - Cluster store to use
- `daemon` - Enable daemon mode
- `data_root` - Root of the Docker runtime
- `debug` - Enable debug mode
- `default_ip_address_pool` - Set the default address pool for networks creates by docker
- `default_ulimit` - Set default ulimit settings for containers
- `disable_legacy_registry` - Do not contact legacy registries
- `dns_search` - DNS search domains to use
- `dns` - DNS server(s) to use
- `exec_driver` - Exec driver to use
- `fixed_cidr_v6` - IPv6 subnet for fixed IPs
- `fixed_cidr` - IPv4 subnet for fixed IPs
- `group` - Posix group for the unix socket. Default to `docker`
- `host` - Daemon socket(s) to connect to - `tcp://host:port`, `unix:///path/to/socket`, `fd://*` or `fd://socketfd`
- `http_proxy` - ENV variable set before for Docker daemon starts
- `https_proxy` - ENV variable set before for Docker daemon starts
- `icc` - Enable inter-container communication
- `insecure_registry` - Enable insecure registry communication
- `install_method` - Select script, package, tarball, none, or auto. Defaults to `auto`.
- `instance`- Optional property used to override the name provided in the resource.
- `ip_forward` - Enable ip forwarding
- `ip_masq` - Enable IP masquerading
- `ip` - Default IP when binding container ports
- `iptables` - Enable addition of iptables rules
- `ipv4_forward` - Enable net.ipv4.ip_forward
- `ipv6_forward` - Enable net.ipv6.ip_forward
- `ipv6` - Enable IPv6 networking
- `labels` A string or array to set metadata on the daemon in the form ['foo:bar', 'hello:world']`
- `log_driver` - Container's logging driver (json-file/syslog/journald/gelf/fluentd/awslogs/splunk/etwlogs/gcplogs/none)
- `log_level` - Set the logging level
- `log_opts` - Container's logging driver options (driver-specific)
- `logfile` - Location of Docker daemon log file
- `mount_flags` - Set the systemd mount propagation flag.
- `mtu` - Set the containers network MTU
- `no_proxy` - ENV variable set before for Docker daemon starts
- `package_name` - Set the package name. Defaults to `docker-ce`
- `pidfile` - Path to use for daemon PID file
- `registry_mirror` - Preferred Docker registry mirror
- `selinux_enabled` - Enable selinux support
- `source` - URL to the pre-compiled Docker binary used for installation. Defaults to a calculated URL based on kernel version, Docker version, and platform arch. By default, this will try to get to "<http://get.docker.io/builds/>".
- `storage_driver` - Storage driver to use
- `storage_opts` - Set storage driver options
- `tls_ca_cert` - Trust certs signed only by this CA. Defaults to ENV['DOCKER_CERT_PATH'] if set
- `tls_client_cert` - Path to TLS certificate file for docker cli. Defaults to ENV['DOCKER_CERT_PATH'] if set
- `tls_client_key` - Path to TLS key file for docker cli. Defaults to ENV['DOCKER_CERT_PATH'] if set
- `tls_server_cert` - Path to TLS certificate file for docker service
- `tls_server_key` - Path to TLS key file for docker service
- `tls_verify` - Use TLS and verify the remote. Defaults to ENV['DOCKER_TLS_VERIFY'] if set
- `tls` - Use TLS; implied by --tlsverify. Defaults to ENV['DOCKER_TLS'] if set
- `tmpdir` - ENV variable set before for Docker daemon starts
- `userland_proxy`- Enables or disables docker-proxy
- `userns_remap` - Enable user namespace remapping options - `default`, `uid`, `uid:gid`, `username`, `username:groupname` (see: [Docker User Namespaces](see: https://docs.docker.com/v1.10/engine/reference/commandline/daemon/#daemon-user-namespace-options))
- `version` - Docker version to install

#### Miscellaneous Options

- `misc_opts` - Pass the docker daemon any other options bypassing flag validation, supplied as `--flag=value`

#### Systemd-specific Options

- `systemd_opts` - An array of strings that will be included as individual lines in the systemd service unit for Docker. _Note_: This option is only relevant for systems where systemd is the default service manager or where systemd is specified explicitly as the service manager.
- `systemd_socket_opts` - An array of strings that will be included as individual lines in the systemd socket unit for Docker. _Note_: This option is only relevant for systems where systemd is the default service manager or where systemd is specified explicitly as the service manager.

### Actions

- `:create` - Lays the Docker bits out on disk
- `:delete` - Removes the Docker bits from the disk
- `:start` - Makes sure the service provider is set up properly and start it
- `:stop` - Stops the service
- `:restart` - Restarts the service

### `docker_service` implementations

- `docker_service_execute` - The simplest docker_service. Just starts a process. Fire and forget.
- `docker_service_sysvinit` - Uses a SystemV init script to manage the service state.
- `docker_service_upstart` - Uses an Upstart script to manage the service state.
- `docker_service_systemd` - Uses an Systemd unit file to manage the service state. NOTE: This does NOT enable systemd socket activation.

## docker_image

The `docker_image` is responsible for managing Docker image pulls, builds, and deletions. It speaks directly to the [Docker Engine API](https://docs.docker.com/engine/api/v1.35/#tag/Image).

### Actions

- `:pull` - Pulls an image from the registry. Default action.
- `:pull_if_missing` - Pulls an image from the registry, only if it missing
- `:build` - Builds an image from a Dockerfile, directory, or tarball
- `:build_if_missing` - Same build, but only if it is missing
- `:save` - Exports an image to a tarball at `destination`
- `:import` - Imports an image from a tarball at `destination`
- `:remove` - Removes (untags) an image
- `:push` - Pushes an image to the registry

### Properties

The `docker_image` resource properties mostly corresponds to the [Docker Engine API](https://docs.docker.com/engine/api/v1.35/#tag/Image) as driven by the [docker-api Ruby gem](https://github.com/swipely/docker-api)

A `docker_image`'s full identifier is a string in the form "\

<repo\>:\<tag\>". There is some nuance around naming using the
public registry vs a private one.</tag\></repo\>

- `repo` - aka `image_name` - The first half of a Docker image's identity. This is a string in the form: `registry:port/owner/image_name`. If the `registry:port` portion is left off, Docker will implicitly use the Docker public registry. "Official Images" omit the owner part. This means a repo id can be as short as `busybox`, `alpine`, or `centos`. These names refer to official images on the public registry. Names can be as long as `my.computers.biz:5043/what/ever` to refer to custom images on an private registry. Often you'll see something like `chef/chef` to refer to private images on the public registry. - Defaults to resource name.
- `tag` - The second half of a Docker image's identity. - Defaults to `latest`
- `source` - Path to input for the `:import`, `:build` and `:build_if_missing` actions. For building, this can be a Dockerfile, a tarball containing a Dockerfile in its root, or a directory containing a Dockerfile. For `:import`, this should be a tarball containing Docker formatted image, as generated with `:save`.
- `destination` - Path for output from the `:save` action.
- `force` - A force boolean used in various actions - Defaults to false
- `nocache` - Used in `:build` operations. - Defaults to false
- `noprune` - Used in `:remove` operations - Defaults to false
- `rm` - Remove intermediate containers after a successful build (default behavior) - Defaults to `true`
- `read_timeout` - May need to increase for long image builds/pulls
- `write_timeout` - May need to increase for long image builds/pulls
- `host` - A string containing the host the API should communicate with. Defaults to `ENV['DOCKER_HOST']` if set.
- `tls` - Use TLS; implied by --tlsverify. Defaults to ENV['DOCKER_TLS'] if set.
- `tls_verify` - Use TLS and verify the remote. Defaults to `ENV['DOCKER_TLS_VERIFY']` if set
- `tls_ca_cert` - Trust certs signed only by this CA. Defaults to `ENV['DOCKER_CERT_PATH']` if set.
- `tls_client_cert` - Path to TLS certificate file for docker cli. Defaults to `ENV['DOCKER_CERT_PATH']` if set
- `tls_client_key` - Path to TLS key file for docker cli. Defaults to `ENV['DOCKER_CERT_PATH']` if set.

### Examples

- default action, default properties

```ruby
docker_image 'hello-world'
```

- non-default name property

```ruby
docker_image "Tom's container" do
  repo 'tduffield/testcontainerd'
  action :pull
end
```

- pull every time

```ruby
docker_image 'busybox' do
  action :pull
end
```

- specify a tag

```ruby
docker_image 'alpine' do
  tag '3.1'
end
```

- specify read/write timeouts

```ruby
docker_image 'alpine' do
  read_timeout 60
  write_timeout 60
end
```

```ruby
docker_image 'vbatts/slackware' do
  action :remove
end
```

- save

```ruby
docker_image 'save hello-world' do
  repo 'hello-world'
  destination '/tmp/hello-world.tar'
  not_if { ::File.exist?('/tmp/hello-world.tar') }
  action :save
end
```

- build from a Dockerfile on every chef-client run

```ruby
docker_image 'image_1' do
  tag 'v0.1.0'
  source '/src/myproject/container1/Dockerfile'
  action :build
end
```

- build from a directory, only if image is missing

```ruby
docker_image 'image_2' do
  tag 'v0.1.0'
  source '/src/myproject/container2'
  action :build_if_missing
end
```

- build from a tarball NOTE: this is not an "export" tarball generated from an an image save. The contents should be a Dockerfile, and anything it references to COPY or ADD

```ruby
docker_image 'image_3' do
  tag 'v0.1.0'
  source '/tmp/image_3.tar'
  action :build
end
```

```ruby
docker_image 'hello-again' do
  tag 'v0.1.0'
  source '/tmp/hello-world.tar'
  action :import
end
```

- push

```ruby
docker_image 'my.computers.biz:5043/someara/hello-again' do
  action :push
end
```

- Connect to an external docker daemon and pull an image

```ruby
docker_image 'alpine' do
  host 'tcp://127.0.0.1:2376'
  tag '2.7'
end
```

## docker_image_prune

The `docker_image_prune` is responsible for pruning Docker images from the system. It speaks directly to the [Docker Engine API](https://docs.docker.com/engine/api/v1.35/#operation/ImagePrune).
Note - this is best implemented by subscribing to `docker_image` changes.  There is no need to to clean up old images upon each converge.  It is best done at the end of a chef run (delayed) only if a new image was pulled.

### Actions

- `:prune` - Delete unused images

### Properties

The `docker_image_prune` resource properties map to filters

- `dangling` - When set to true (or 1), prune only unused and untagged images. When set to false (or 0), all unused images are pruned
- `prune_until` - Prune images created before this timestamp. The <timestamp> can be Unix timestamps, date formatted timestamps, or Go duration strings (e.g. 10m, 1h30m) computed relative to the daemon machine’s time.
- `with_label/without_label` -  (label=<key>, label=<key>=<value>, label!=<key>, or label!=<key>=<value>) Prune images with (or without, in case label!=... is used) the specified labels.
- `host` - A string containing the host the API should communicate with. Defaults to `ENV['DOCKER_HOST']` if set.

### Examples

- default action, default properties

```ruby
docker_image_prune 'prune-old-images'
```

- All filters

```ruby
docker_image_prune "prune-old-images" do
  dangling true
  prune_until '1h30m'
  with_label 'com.example.vendor=ACME'
  without_label 'no_prune'
  action :prune
end
```

## docker_tag

Docker tags work very much like hard links in a Unix filesystem. They are just references to an existing image. Therefore, the docker_tag resource has taken inspiration from the Chef `link` resource.

### Actions

- `:tag` - Tags the image

### Properties

- `target_repo` - The repo half of the source image identifier.
- `target_tag` - The tag half of the source image identifier.
- `to_repo` - The repo half of the new image identifier
- `to_tag`- The tag half of the new image identifier

### Examples

```ruby
docker_tag 'private repo tag for hello-again:1.0.1' do
  target_repo 'hello-again'
  target_tag 'v0.1.0'
  to_repo 'localhost:5043/someara/hello-again'
  to_tag 'latest'
  action :tag
end
```

## docker_container

The `docker_container` is responsible for managing Docker container actions. It speaks directly to the [Docker remote API](https://docs.docker.com/reference/api/docker_remote_api_v1.20/).

Containers are process oriented, and move through an event cycle. Thanks to [Glider Labs](http://gliderlabs.com/) for this excellent diagram. ![alt tag](https://gliderlabs.com/images/2015/docker_events.png)

### Actions

- `:create` - Creates the container but does not start it. Useful for Volume containers.
- `:start` - Starts the container. Useful for containers that run jobs.. command that exit.
- `:run` - The default action. Both `:create` and `:start` the container in one action. Redeploys the container on resource change.
- `:run_if_missing` - Runs a container only once.
- `:stop` - Stops the container.
- `:restart` - Stops and then starts the container.
- `:kill` - Send a signal to the container process. Defaults to `SIGKILL`.
- `:pause` - Pauses the container.
- `:unpause` - Unpauses the container.
- `:delete` - Deletes the container.
- `:redeploy` - Deletes and runs the container.
- `:reload` - Sends SIGHUP to pid 1 in the container

### Properties

Most `docker_container` properties are the `snake_case` version of the `CamelCase` keys found in the [Docker Remote Api](https://docs.docker.com/reference/api/docker_remote_api_v1.20/)

- `container_name` - The name of the container. Defaults to the name of the `docker_container` resource.
- `repo` - aka `image_name`. The first half of a the complete identifier for a Docker Image.
- `tag` - The second half of a Docker image's identity. - Defaults to `latest`.
- `command` - The command to run when starting the container.
- `autoremove` - Boolean - Automatically delete a container when it's command exits. Defaults to `false`.
- `volumes` - An array of volume bindings for this container. Each volume binding is a string in one of these forms: `container_path` to create a new volume for the container. `host_path:container_path` to bind-mount a host path into the container. `host_path:container_path:ro` to make the bind-mount read-only inside the container.
- `cap_add` - An array Linux Capabilities (`man 7 capabilities`) to add to grant the container beyond what it normally gets.
- `cap_drop` - An array Linux Capabilities (`man 7 capabilities`) to revoke that the container normally has.
- `cpu_shares` - An integer value containing the CPU Shares for the container.
- `devices` - A Hash of devices to add to the container.
- `dns` - An array of DNS servers the container will use for name resolution.
- `dns_search` - An array of domains the container will search for name resolution.
- `domain_name` - Set's the container's dnsdomainname as returned by the `dnsdomainname` command.
- `entrypoint` - Set the entry point for the container as a string or an array of strings.
- `env` - Set environment variables in the container in the form `['FOO=bar', 'BIZ=baz']`
- `env_file` - Read environment variables from a file and set in the container. Accepts an Array or String to the file location. lazy evaluator must be set if the file passed is created by Chef.
- `extra_hosts` - An array of hosts to add to the container's `/etc/hosts` in the form `['host_a:10.9.8.7', 'host_b:10.9.8.6']`
- `force` - A boolean to use in container operations that support a `force` option. Defaults to `false`
- `health_check` - A hash containing the health check options - https://docs.docker.com/engine/reference/run/#healthcheck
- `host` - A string containing the host the API should communicate with. Defaults to ENV['DOCKER_HOST'] if set
- `host_name` - The hostname for the container.
- `labels` A string, array, or hash to set metadata on the container in the form ['foo:bar', 'hello:world']`
- `links` - An array of source container/alias pairs to link the container to in the form `[container_a:www', container_b:db']`
- `log_driver` - Sets a custom logging driver for the container (json-file/syslog/journald/gelf/fluentd/none).
- `log_opts` - Configures the above logging driver options (driver-specific).
- `init` - Run an init inside the container that forwards signals and reaps processes.
- `ip_address` - Container IPv4 address (e.g. 172.30.100.104)
- `mac_address` - The mac address for the container to use.
- `memory` - Memory limit in bytes.
- `memory_swap` - Total memory limit (memory + swap); set `-1` to disable swap limit (unlimited). You must use this with memory and make the swap value larger than memory.
- `network_disabled` - Boolean to disable networking. Defaults to `false`.
- `network_mode` - Sets the networking mode for the container. One of `bridge`, `host`, `container`.
- `network_aliases` - Adds network-scoped alias for the container in form `['alias-1', 'alias-2']`.
- `oom_kill_disable` - Whether to disable OOM Killer for the container or not.
- `oom_score_adj` - Tune container's OOM preferences (-1000 to 1000).
- `open_stdin` - Boolean value, opens stdin. Defaults to `false`.
- `outfile` - The path to write the file when using `:export` action.
- `port` - The port configuration to use in the container. Matches the syntax used by the `docker` CLI tool.
- `privileged` - Boolean to start the container in privileged more. Defaults to `false`
- `publish_all_ports` - Allocates a random host port for all of a container's exposed ports.
- `remove_volumes` - A boolean to clean up "dangling" volumes when removing the last container with a reference to it. Default to `false` to match the Docker CLI behavior.
- `restart_policy` - One of `no`, `on-failure`, `unless-stopped`, or `always`. Use `always` if you want a service container to survive a Dockerhost reboot. Defaults to `no`.
- `restart_maximum_retry_count` - Maximum number of restarts to try when `restart_policy` is `on-failure`. Defaults to an ever increasing delay (double the previous delay, starting at 100mS), to prevent flooding the server.
- `running_wait_time` - Amount of seconds `docker_container` wait to determine if a process is running.
- `runtime` - Runtime to use when running container. Defaults to `runc`.
- `security_opt` - A list of string values to customize labels for MLS systems, such as SELinux.
- `shm_size` - The size of `/dev/shm`. The format is `<number><unit>`, where number must be greater than 0. Unit is optional and can be b (bytes), k (kilobytes), m(megabytes), or g (gigabytes). The default is `64m`.
- `signal` - The signal to send when using the `:kill` action. Defaults to `SIGTERM`.
- `sysctls` - A hash of sysctls to set on the container. Defaults to `{}`.
- `tty` - Boolean value to allocate a pseudo-TTY. Defaults to `false`.
- `user` - A string value specifying the user inside the container.
- `volumes` - An Array of paths inside the container to expose. Does the same thing as the `VOLUME` directive in a Dockerfile, but works on container creation.
- `volumes_from` - A list of volumes to inherit from another container. Specified in the form `<container name>[:<ro|rw>]`
- `volume_driver` - Driver that this container users to mount volumes.
- `working_dir` - A string specifying the working directory for commands to run in.
- `read_timeout` - May need to increase for commits or exports that are slow
- `write_timeout` - May need to increase for commits or exports that are slow
- `kill_after` - Number of seconds to wait before killing the container. Defaults to wait indefinitely; eventually will hit read_timeout limit.
- `timeout` - Seconds to wait for an attached container to return
- `tls` - Use TLS; implied by --tlsverify. Defaults to ENV['DOCKER_TLS'] if set
- `tls_verify` - Use TLS and verify the remote. Defaults to ENV['DOCKER_TLS_VERIFY'] if set
- `tls_ca_cert` - Trust certs signed only by this CA. Defaults to ENV['DOCKER_CERT_PATH'] if set
- `tls_client_cert` - Path to TLS certificate file for docker cli. Defaults to ENV['DOCKER_CERT_PATH'] if set
- `tls_client_key` - Path to TLS key file for docker cli. Defaults to ENV['DOCKER_CERT_PATH'] if set
- `userns_mode` - Modify the user namespace mode - Defaults to `nil`, example option: `host`
- `pid_mode` - Set the PID (Process) Namespace mode for the container. `host`: use the host's PID namespace inside the container.
- `ipc_mode` - Set the IPC mode for the container - Defaults to `nil`, example option: `host`
- `uts_mode` - Set the UTS namespace mode for the container. The UTS namespace is for setting the hostname and the domain that is visible to running processes in that namespace. By default, all containers, including those with `--network=host`, have their own UTS namespace. The host setting will result in the container using the same UTS namespace as the host. Note that --hostname is invalid in host UTS mode.
- `ro_rootfs` - Mount the container's root filesystem as read only using the `--read-only` flag. Defaults to `false`

### Examples

- Create a container without starting it.

```ruby
docker_container 'hello-world' do
  command '/hello'
  action :create
end
```

- This will exit succesfully. It will happen on every chef-client run.

```ruby
docker_container 'busybox_ls' do
  repo 'busybox'
  command 'ls -la /'
  action :run
end
```

- The :run action contains both :create and :start the container in one action. Redeploys the container on resource change. It is the default action.

```ruby
docker_container 'alpine_ls' do
  repo 'alpine'
  tag '3.1'
  command 'ls -la /'
  action :run
end
```

- Set environment variables in a container

```ruby
docker_container 'env' do
  repo 'debian'
  env ['PATH=/usr/bin', 'FOO=bar']
  command 'env'
  action :run
end
```

```ruby
docker_container 'env_files' do
  repo 'debian'
  env_file lazy { ['/env_file1', '/env_file2'] }
  command 'env'
  action :run
end
```

- This process remains running between chef-client runs, :run will do nothing on subsequent converges.

```ruby
docker_container 'an_echo_server' do
  repo 'alpine'
  tag '3.1'
  command 'nc -ll -p 7 -e /bin/cat'
  port '7:7'
  action :run
end
```

- Let docker pick the host port

```ruby
docker_container 'another_echo_server' do
  repo 'alpine'
  tag '3.1'
  command 'nc -ll -p 7 -e /bin/cat'
  port '7'
  action :run
end
```

- Specify the udp protocol

```ruby
docker_container 'an_udp_echo_server' do
  repo 'alpine'
  tag '3.1'
  command 'nc -ul -p 7 -e /bin/cat'
  port '5007:7/udp'
  action :run
end
```

- Kill a container

```ruby
docker_container 'bill' do
  action :kill
end
```

- Stop a container

```ruby
docker_container 'hammer_time' do
  action :stop
end
```

- Force-stop a container after 30 seconds

```ruby
docker_container 'hammer_time' do
  kill_after 30
  action :stop
end
```

- Pause a container

```ruby
docker_container 'red_light' do
  action :pause
end
```

- Unpause a container

```ruby
docker_container 'green_light' do
  action :unpause
end
```

- Restart a container

```ruby
docker_container 'restarter' do
  action :restart
end
```

- Delete a container

```ruby
docker_container 'deleteme' do
  remove_volumes true
  action :delete
end
```

- Redeploy a container

```ruby
docker_container 'redeployer' do
  repo 'alpine'
  tag '3.1'
  command 'nc -ll -p 7777 -e /bin/cat'
  port '7'
  action :run
end

execute 'redeploy redeployer' do
  notifies :redeploy, 'docker_container[redeployer]', :immediately
  action :run
end
```

- Bind mount local directories

```ruby
docker_container 'bind_mounter' do
  repo 'busybox'
  command 'ls -la /bits /more-bits'
  volumes ['/hostbits:/bits', '/more-hostbits:/more-bits']
  action :run_if_missing
end
```

- Mount volumes from another container

```ruby
docker_container 'chef_container' do
  command 'true'
  volumes '/opt/chef'
  action :create
end

docker_container 'ohai_debian' do
  command '/opt/chef/embedded/bin/ohai platform'
  repo 'debian'
  volumes_from 'chef_container'
end
```

- Set a container's entrypoint

```ruby
docker_container 'ohai_again_debian' do
  repo 'debian'
  volumes_from 'chef_container'
  entrypoint '/opt/chef/embedded/bin/ohai'
  command 'platform'
  action :run_if_missing
end
```

- Automatically remove a container after it exits

```ruby
docker_container 'sean_was_here' do
  command "touch /opt/chef/sean_was_here-#{Time.new.strftime('%Y%m%d%H%M')}"
  repo 'debian'
  volumes_from 'chef_container'
  autoremove true
  action :run
end
```

- Grant NET_ADMIN rights to a container

```ruby
docker_container 'cap_add_net_admin' do
  repo 'debian'
  command 'bash -c "ip addr add 10.9.8.7/24 brd + dev eth0 label eth0:0 ; ip addr list"'
  cap_add 'NET_ADMIN'
  action :run_if_missing
end
```

- Revoke MKNOD rights to a container

```ruby
docker_container 'cap_drop_mknod' do
  repo 'debian'
  command 'bash -c "mknod -m 444 /dev/urandom2 c 1 9 ; ls -la /dev/urandom2"'
  cap_drop 'MKNOD'
  action :run_if_missing
end
```

- Set a container's hostname and domainname

```ruby
docker_container 'fqdn' do
  repo 'debian'
  command 'hostname -f'
  host_name 'computers'
  domain_name 'biz'
  action :run_if_missing
end
```

- Set a container's DNS resolution

```ruby
docker_container 'dns' do
  repo 'debian'
  command 'cat /etc/resolv.conf'
  host_name 'computers'
  dns ['4.3.2.1', '1.2.3.4']
  dns_search ['computers.biz', 'chef.io']
  action :run_if_missing
end
```

- Add extra hosts to a container's `/etc/hosts`

```ruby
docker_container 'extra_hosts' do
  repo 'debian'
  command 'cat /etc/hosts'
  extra_hosts ['east:4.3.2.1', 'west:1.2.3.4']
  action :run_if_missing
end
```

- Manage container's restart_policy

```ruby
docker_container 'try_try_again' do
  repo 'alpine'
  tag '3.1'
  command 'grep asdasdasd /etc/passwd'
  restart_policy 'on-failure'
  restart_maximum_retry_count 2
  action :run_if_missing
end

docker_container 'reboot_survivor' do
  repo 'alpine'
  tag '3.1'
  command 'nc -ll -p 123 -e /bin/cat'
  port '123'
  restart_policy 'always'
  action :run_if_missing
end
```

- Manage container links

```ruby
docker_container 'link_source' do
  repo 'alpine'
  tag '3.1'
  env ['FOO=bar', 'BIZ=baz']
  command 'nc -ll -p 321 -e /bin/cat'
  port '321'
  action :run_if_missing
end

docker_container 'link_target_1' do
  repo 'alpine'
  tag '3.1'
  env ['ASD=asd']
  command 'ping -c 1 hello'
  links ['link_source:hello']
  action :run_if_missing
end

docker_container 'link_target_2' do
  repo 'alpine'
  tag '3.1'
  command 'env'
  links ['link_source:hello']
  action :run_if_missing
end

execute 'redeploy_link_source' do
  command 'touch /marker_container_redeploy_link_source'
  creates '/marker_container_redeploy_link_source'
  notifies :redeploy, 'docker_container[link_source]', :immediately
  notifies :redeploy, 'docker_container[link_target_1]', :immediately
  notifies :redeploy, 'docker_container[link_target_2]', :immediately
  action :run
end
```

- Mutate a container between chef-client runs

```ruby
docker_tag 'mutator_from_busybox' do
  target_repo 'busybox'
  target_tag 'latest'
  to_repo 'someara/mutator'
  target_tag 'latest'
end

docker_container 'mutator' do
  repo 'someara/mutator'
  tag 'latest'
  command "sh -c 'touch /mutator-`date +\"%Y-%m-%d_%H-%M-%S\"`'"
  outfile '/mutator.tar'
  force true
  action :run_if_missing
end

execute 'commit mutator' do
  command 'true'
  notifies :commit, 'docker_container[mutator]', :immediately
  notifies :export, 'docker_container[mutator]', :immediately
  notifies :redeploy, 'docker_container[mutator]', :immediately
  action :run
end
```

- Specify read/write timeouts

```ruby
docker_container 'api_timeouts' do
  repo 'alpine'
  read_timeout 60
  write_timeout 60
end
```

- Specify a custom logging driver and its options

```ruby
docker_container 'syslogger' do
  repo 'alpine'
  tag '3.1'
  command 'nc -ll -p 780 -e /bin/cat'
  log_driver 'syslog'
  log_opts 'tag=container-syslogger'
end
```

- Connect to an external docker daemon and create a container

```ruby
docker_container 'external_daemon' do
  repo 'alpine'
  host 'tcp://1.2.3.4:2376'
  action :create
end
```

- Run a container with health_check options

```ruby
docker_container 'health_check' do
  repo 'alpine'
  tag '3.1'
  health_check ({
    "Test" =>
      [
        "string"
      ],
      "Interval" => 0,
      "Timeout" => 0,
      "Retries" => 0,
      "StartPeriod" => 0
  })
  action :run
end
```

## docker_registry

The `docker_registry` resource is responsible for managing the connection auth information to a Docker registry.

### Actions

- `:login` - Login to the Docker Registry

### Properties

- `email`
- `password`
- `serveraddress`
- `username`

### Examples

- Log into or register with public registry:

```ruby
docker_registry 'https://index.docker.io/v1/' do
  username 'publicme'
  password 'hope_this_is_in_encrypted_databag'
  email 'publicme@computers.biz'
end
```

Log into private registry with optional port:

```ruby
docker_registry 'my local registry' do
   serveraddress 'https://registry.computers.biz:8443/'
   username 'privateme'
   password 'still_hope_this_is_in_encrypted_databag'
   email 'privateme@computers.biz'
end
```

## docker_network

The `docker_network` resource is responsible for managing Docker named networks. Usage of `overlay` driver requires the `docker_service` to be configured to use a distributed key/value store like `etcd`, `consul`, or `zookeeper`.

### Actions

- `:create` - create a network
- `:delete` - delete a network
- `:connect` - connect a container to a network
- `:disconnect` - disconnect a container from a network

### Properties

- `aux_address` - Auxiliary addresses for the network. Ex: `['a=192.168.1.5', 'b=192.168.1.6']`
- `container` - Container-id/name to be connected/disconnected to/from the network. Used only by `:connect` and `:disconnect` actions
- `driver` - The network driver to use. Defaults to `bridge`, other options include `overlay`.
- `enable_ipv6` - Enable IPv6 on the network. Ex: true
- `gateway` - Specify the gateway(s) for the network. Ex: `192.168.0.1`
- `ip_range` - Specify a range of IPs to allocate for containers. Ex: `192.168.1.0/24`
- `subnet` - Specify the subnet(s) for the network. Ex: `192.168.0.0/16`

### Examples

Create a network and use it in a container

```ruby
docker_network 'network_g' do
  driver 'overlay'
  subnet ['192.168.0.0/16', '192.170.0.0/16']
  gateway ['192.168.0.100', '192.170.0.100']
  ip_range '192.168.1.0/24'
  aux_address ['a=192.168.1.5', 'b=192.168.1.6', 'a=192.170.1.5', 'b=192.170.1.6']
end

docker_container 'echo-base' do
  repo 'alpine'
  tag '3.1'
  command 'nc -ll -p 1337 -e /bin/cat'
  port '1337'
  network_mode 'network_g'
  action :run
end
```

Connect to multiple networks

```ruby
docker_network 'network_h1' do
  action :create
end

docker_network 'network_h2' do
  action :create
end

docker_container 'echo-base-networks_h' do
  repo 'alpine'
  tag '3.1'
  command 'nc -ll -p 1337 -e /bin/cat'
  port '1337'
  network_mode 'network_h1'
  action :run
end

docker_network 'network_h2' do
  container 'echo-base-networks_h'
  action :connect
end
```

IPv6 enabled network

```ruby
docker_network 'network_i1' do
  enable_ipv6 true
  subnet 'fd00:dead:beef::/48'
  action :create
end
```

## docker_volume

The `docker_volume` resource is responsible for managing Docker named volumes.

### Actions

- `:create` - create a volume
- `:remove` - remove a volume

### Properties

- `driver` - Name of the volume driver to use. Only used for `:create`.
- `host`
- `opts` - Options to pass to the volume driver. Only used for `:create`.
- `volume`
- `volume_name` - Name of the volume to operate on (defaults to the resource name).

### Examples

Create a volume named 'hello'

```ruby
docker_volume 'hello' do
  action :create
end

docker_container 'file_writer' do
  repo 'alpine'
  tag '3.1'
  volumes 'hello:/hello'
  command 'touch /hello/sean_was_here'
  action :run_if_missing
end
```

## docker_plugin

The `docker_plugin` resource allows you to install, configure, enable, disable and remove [Docker Engine managed plugins](https://docs.docker.com/engine/extend/).

### Actions

- `:install` - Install and configure a plugin if it is not already installed
- `:update` - Re-configure a plugin
- `:enable` - Enable a plugin (needs to be done after `:install` before it can
  be used)
- `:disable` - Disable a plugin (needs to be done before removing a plugin)
- `:remove` - Remove a disabled plugin

### Properties

- `local_alias` - Local name for the plugin (defaults to the resource name).
- `remote` - Ref of the plugin (e.g. `vieux/sshfs`). Defaults to `local_alias` or the resource name. Only used for `:install`.
- `remote_tag` - Remote tag of the plugin to pull (e.g. `1.0.1`, defaults to `latest`) Only used for `:install`.
- `options` - Hash of options to set on the plugin. Only used for `:update` and `:install`.
- `grant_privileges` - Array of privileges or true. If it is true, all privileges requested by the plugin will be automatically granted (potentially dangerous). Otherwise, this must be an array in the same format as returned by the [`/plugins/privileges` docker API](https://docs.docker.com/engine/api/v1.37/#operation/GetPluginPrivileges) endpoint. If the array of privileges is not sufficient for the plugin, docker will reject it and the installation will fail. Defaults to `[]` (empty array => no privileges). Only used for `:install`. Does not modify the privileges of already-installed plugins.

### Examples

```ruby
docker_plugin 'rbd' do
  remote 'wetopi/rbd'
  remote_tag '1.0.1'
  grant_privileges true
  options(
    'RBD_CONF_POOL' => 'docker_volumes'
  )
end
```

## docker_exec

The `docker_exec` resource allows you to execute commands inside of a running container.

### Actions

- `:run` - Runs the command

### Properties

- `host` - Daemon socket(s) to connect to - `tcp://host:port`, `unix:///path/to/socket`, `fd://*` or `fd://socketfd`.
- `command` - A command structured as an Array similar to `CMD` in a Dockerfile.
- `container` - Name of the container to execute the command in.
- `timeout`- Seconds to wait for an attached container to return. Defaults to 60 seconds.
- `container_obj`

### Examples

```ruby
docker_exec 'touch_it' do
  container 'busybox_exec'
  command ['touch', '/tmp/onefile']
end
```

## Maintainers

- Sean OMeara ([sean@sean.io](mailto:sean@sean.io))
- Brian Flad ([bflad417@gmail.com](mailto:bflad417@gmail.com))
- Chase Bolt ([chase.bolt@gmail.com](mailto:chase.bolt@gmail.com))

## License

**Copyright:** 2015-2018, Chef Software, Inc.

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
