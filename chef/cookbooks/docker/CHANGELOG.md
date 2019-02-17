# Docker Cookbook Changelog

This file is used to list changes made in each version of the docker cookbook.

## 4.9.2 (2019-02-15)

- Support setting shared memory size.

## 4.9.1 (2019-02-01)

- added systemd_socket_opts for additional configuration of the systemd socket file

## 4.9.0 (2018-12-17)

- Add support for windows - [@smcavallo](https://github.com/smcavallo)
- Expand ChefSpec testing - [@smcavallo](https://github.com/smcavallo)
- Fix for when HealthCheck is used - [@smcavallo](https://github.com/smcavallo)

## 4.8.0 (2018-12-09)

- Fix issues with network_mode in docker_container - [@smcavallo](https://github.com/smcavallo)
- Add support for container health_check options - [@smcavallo](https://github.com/smcavallo)
- Add new docker_image_prune resource - [@smcavallo](https://github.com/smcavallo)

## 4.7.0 (2018-12-05)

- Added 17.03 support on RHEL 7. Thanks @smcavallo
- Added 18.09 support. Thanks @smcavallo

## 4.6.8 (2018-11-27)

- add missing new_resource reference that prevented docker_container's reload action from running

## 4.6.7 (2018-10-10)

- Add :default_address_pool property to docker_service
- Import docker.com repository gpg key via HTTPS directly from docker to avoid timeouts with Ubuntu's key registry

## 4.6.6 (unreleased)

- :default_ip_address_pool property added to configure default address pool for networks created by Docker.

## 4.6.5 (2018-09-04)

- package names changed again. looks like they swapped xenial and bionic name schema.

## 4.6.4 (2018-08-29)

- xenial 18.03 contains the new test version format

## 4.6.3 (2018-08-23)

- refactor version_string

## 4.6.2 (2018-08-23)

- Use different version string on .deb packages

## 4.6.1 (2018-08-21)

- Include setup_docker_repo in docker_service and allow old docker-ce versions for centos

## 4.6.0 (2018-08-19)

- Bump docker version to 18.06.0

## 4.5.0 (2018-08-16)

- sets the default log_level for the systemd docker service back to nil
- change require relative to library path
- docker_execute -> docker_exec
- Loosen up the requirement on docker-api gem
- Add new docker_plugin resource

## 4.4.1 (2018-07-23)

- Adding tests for docker_container detach == false (container is attached)
- Add new_resource and current_resource objects as context for methods when telling a container to wait (when detach is false)

## 4.4.0 (2018-07-17)

- docker service :log_level property converted to String.
- Use new package versioning scheme for Ubuntu bionic
- Bump the docker version everywhere

## 4.3.0 (2018-06-19)

- Remove the zesty? helper
- Initial support for Debian Buster (10)
- Bump the package default to 18.03.0
- Remove old integration tests
- Update package specs to pass on Amazon Linux

## 4.2.0 (2018-04-09)

- Initial support for Chef 14
- Remove unused api_version helper
- Support additional sysv RHEL like platforms by using platform_family
- Added oom_kill_disable and oom_score_adj support to docker_container
- ENV returns nil if the variable isn't found
- Remove the TLS default helpers
- Move coerce_labels into docker_container where its used
- Add desired_state false to a few more properties
- If the ENV values are nil don't use them to build busted defaults for TLS
- Remove a giant pile of Chef 12-isms
- Kill off ArrayType and NonEmptyArray types
- Don't require docker all over the place
- Kill the ShellCommand type
- Fix undefined method `v' for DockerContainer
- Make to_shellwords idempotent in DockerContainer
- Fix(Chef14): Use property_is_set with new_resource
- Use try-restart for systemd & retry start one time

## 4.1.1 (2018-03-11)

- Move to_snake_case to the container resource where it's used
- Reduce the number of coerce helpers in the the container resource
- Remove the Boolean type and instead just use TrueClass,FalseClass
- Use an actual integer in the memory_swappiness test since after reworking the coerce helpers we're requiring what we always stated we required here

## 4.1.0 (2018-03-10)

- Remove required from the name property. This resolves Foodcritic warnings in Foodcritic 13
- Resolve a pile of Chef 14 deprecation warnings in the container and images resources
- Remove support for Ubuntu 17.04 from the installation_package resource
- Moved all the helper libraries into the resources themselves. This is part 1 of the work to get these resources ready for inclusion in Chef 14
- Removed the version logic from installation_package when on Amazon Linux. Since we don't setup the repo we only have a single version available to us and we should just install that version. This resolves the constant need to update the hardcoded version in the cookbook every time Amazon releases a new Docker version.

## 4.0.2 (2018-03-05)

- Flag registry password property as sensitive in docker_registry resource

## 4.0.1 (2018-02-07)

- allow labels to have colons in the value

## 4.0.0 (2018-01-15)

### Breaking Changes

- Default to Docker 17.12.0
- Remove previously deprecated support for Debian 7 / CentOS 6\. Currently supported released of Docker do not run on these platforms.
- Removed support for the EOL Docker 1.12.3
- Removed the ChefSpec matchers which are no longer needed with ChefDK 2.X
- Remove the broken legacy binary installation resource. This was only used by very old EOL docker releases
- By default setup the apt/yum repos in the package install resource so that out of the box there's no need for additional cookbooks. If you would like to manage your own docker repos or other internal repos this may be disabled by property. Due to this change the cookbook now requires Chef 12.15+

### Other Changes

- Greatly expand Travis CI testing of the cookbook and use new InSpec resources for Docker instead of shelling out
- Add support for Ubuntu 17.10
- Update Fedora support for new DNF support in Chef
- Minor correctness and formatting updates to the readme
- load internal and ipv6 status for existing docker_network resources
- Update Amazon Linux to default to 17.09.1, which is the current version in their repos
- Fix the remove action in docker_installation_script
- Replace deprecated graph with data_root. Graph will now silently map to data_root
- Pass --host instead of -H in docker_service for clarity
- Make sure tar is installed to decompress the tarball in the docker_installation_tarball resource
- Update the download path for Docker CE to unbreak docker_installation_tarball
- Allow specifying channels in the docker_installation_tarball resource so you can install non-stable releases

## 3.0.0 (2017-12-22)

- Install docker-api via gem metadata. This bumps the required chef release for this cookbook to 12.10+
- Removed support for Ubuntu Precise
- Reworked the init system detection logic to work on additional platforms and without hardcoded distro version numbers
- Removed shasums from the binary installation resource for Docker 1.6-1.9.1 which are long ago EOL Docker releases
- Test on newer releases of openSUSE and Fedora and test on the latest Docker release

## 2.17.0 (2017-11-10)

- Update Amazon Linux to default to 17.06.2

## 2.16.4 (2017-10-30)

- quote log_opt

## 2.16.3 (2017-10-26)

- add init support to docker_container

## 2.16.2 (2017-10-05)

- fix for ip_address not being set

## 2.16.1 (2017-10-05)

- added support for env_file property
- bumping to 17.09.0

## 2.16.0 (2017-09-18)

- Use docker-api 1.33.6 which includes a few fixes
- This cookbook actually requires Chef 12.7+ so make sure that's mentioned everywhere
- Simplify debian/ubuntu detection code
- Remove support for long ago EOL Ubuntu distros like 15.04/15.10
- Update Amazon Linux to default to 17.03.2

## 2.15.29 (2017-09-12)

- Resolve Chef 14 deprecation warnings in docker_network
- Resolve new_resource warnings in docker_service
- Remove yum from the Berksfile

## 2.15.28 (2017-09-07)

- bumping to 17.06.2
- GH-910 image push needs to pass the credentials and a specific tag

## 2.15.27 (2017-08-31)

- restart docker on rhel sysvinit changes

## 2.15.26 (2017-08-25)

- bumping to 17.06.1
- support for debian 9

## 2.15.25 (2017-08-24)

- notifying :stop and :start instead of :restart in upstart service manager

## 2.15.24 (2017-08-20)

- Supporting env_vars and using in systemd

## 2.15.23 (2017-08-20)

- Fixing bug in volumes introduced with namespacing fixes

## 2.15.22 (2017-08-20)

- Fixing up deprecation warnings

## 2.15.21 (2017-08-07)

- fix to_bytes parsing
- host port can now be a range and matches properly with container port range
- typo on security_opt
- fix for docker_service not containing a listening socket

## 2.15.20 (2017-08-04)

- Using stable docker package version numbers

## 2.15.19 (2017-08-04)

- reverting default_group
- adding docker group to README

## 2.15.18 (2017-07-20)

- create the socket first so restarts on the service unit file don't fail
- redhat defaults to a different group name
- socket group shouldn't be hardcoded
- docker_network: support ipv6 & internal

## 2.15.17 (2017-07-18)

- adding restart notifications to upstart and cleaning house on the configs
- fix docker socket group being empty
- bring systemd unit file closer to stock

## 2.15.16 (2017-07-14)

- Issue #849 Fix service restarts on OS using systemd

## 2.15.15 (2017-07-10)

- upstream systemd config no longer contains the slave mount flag

## 2.15.14 (2017-07-03)

- Simplifying kitchen config
- Using dokken-images to speed up tests
- Updating Amazon Linux to default to 17.03.1
- Package helper for Debian 9

## 2.15.13 (2017-06-15)

- kill_after property default value to nil
- only use --raw-logs argument in versions which support it

## 2.15.12 (2017-06-13)

- reverting gem metadata for now as it requires build tools dependency for the json gem

## 2.15.11 (2017-06-13)

- make docker.service override match closer to stock

## 2.15.10 (2017-06-13)

- adding support for chef >= 12.8 metadata gem installs
- using docker-api 1.33.4

## 2.15.9 (2017-06-13)

- updating systemd docker.service with changes from official docker install
- 12.04 doesn't support docker 17.05.0

## 2.15.8 (2017-06-12)

- Bumping to latest docker version

## 2.15.7 (2017-06-12)

- Adding Ubuntu Zesty 17.04 support

## 2.15.6 (2017-05-01)

- # 853 - Add network_aliases support

- # 854 - Expose package_name through the docker_service resource

## 2.15.5 (2017-04-19)

- Fixing up memory related API keys
- Adding KernelMemory
- Adding MemorySwappiness
- Adding MemoryReservation
- Fixing MemorySwap convergatude (bug #833)
- Allowing for both integer and string input for all memory values

## 2.15.4 (2017-04-19)

- Fixing security_opt property

## 2.15.3 (2017-04-18)

- Updating for 17.04.0

## 2.15.2 (2017-02-15)

- Reverting 12.15.1 changes

## 2.15.1 (2017-02-15)

- 799 - Adding service restarts to systemd template resources

## 2.15.0 (2017-02-15)

- Removing dependency on compat_resource.
- Now requires Chef 12.5 or higher.

## 2.14.3 (2017-02-14)

- Defaulting package installation version to docker 1.13.1

## 2.14.3 (2017-02-06)

- Reverting gem vendor due to c extensions in json dep.
- Using docker-api-1.33.2 in _autoload

## 2.14.2 (2017-01-31)

- Vendoring docker-api-1.33.2

## 2.14.1 (2017-01-31)

- defaulting to package installation on Amazon Linux

## 2.14.0 (2017-01-31)

- various updates for Docker 1.13.0
- defaulting to 1.13.0 for docker_installation
- package name fixes for new debian/ubuntu schemes
- defaulting restart_policy to nil in docker_resource

## 2.13.11 (2017-01-25)

- # 798 - Temporary "fix" for delayed service restart: using :immediate

  notification in docker_service resource

## 2.13.10 (2017-01-13)

- # 800 - fixing ubuntu startup script

- # 802 - using chef_version metadata property only in 12.6.0 and higher

## 2.13.9 (2016-12-29)

- 793 - Removing service restarts due to chef-client behavior changes.

## 2.13.8 (2016-12-28)

- # 794 - network mode bridge

- removing emacs package in upstart provider

- Adding dokken / travis test matrix

## 2.13.7 (2016-12-24)

- adding additional logging drivers
- adding action :reload

## 2.13.6 (2016-12-22)

- adding ip_address support for docker_containers
- adding volume_driver support

## 2.13.5 (2016-12-21)

- Temporary work around for broke upstart provider in chef-client
- Fixing package name for ubuntu version later than 1.12.3

## 2.13.4 (2016-12-20)

- Fixing comparison operator docker daemon args for versions < 1.12

## 2.13.3 (2016-12-20)

- 792 - Reverting 791 fix

## 2.13.2 (2016-12-20)

- 791 - Fix logic bug in docker_service daemon args calculation

## 2.13.1 (2016-12-19)

- # 786 - Adding options hash to docker_volume connection

- # 787 - Adding wait loop to docker_service_manager_execute :stop

## 2.13.0 (2016-11-25)

- Adding sysctl property to docker_container resource

## 2.12.0 (2016-11-25)

- Updating compat_resource dep to 12.16.2
- Updating docker-api gem dep 1.32.1

## 2.11.1 (2016-11-24)

- Fix for #701 - Revert commit that caused restart loops in systemd provider

## 2.11.0 (2016-11-23)

- make systemd MountFlags configurable
- make running wait time configurable

## 2.10.0 (2016-11-23)

- Implement network connect/disconnect
- Fixed dns options mutual exclusion
- Misc test harness cleanup

## 2.9.10 (2016-11-14)

-renaming systemd_conf to systemd_args due to a conflict with systemd cookbook

## 2.9.9 (2016-11-14)

-Fixing resource idempotence in labels property -Fix regression introduced by #741, breaking Debian installation -Added ro_rootfs => ReadonlyRootfs special cases mapping -Enable systemd options as a docker_service attribute

## 2.9.8 (2016-11-08)

- Fixed a typo in an error message
- Enable tarball install through docker_service
- option log_opt is defined as --log-opt value1 --log-opt value2 instead of --log-opt=value1 --log-opt=value2
- Depend on a working compat_resource cookbook

## 2.9.7 (2016-10-14)

- Require the most recent compat_resource
- Get foodcritic passing
- Update the Rakefile and use cookstyle
- Use cookstyle in Travis
- Add matchers for docker_installation_tarball

## v2.9.6

- entrypoint not entry_point README
- dockerd binary on 1.12+ for upstart
- fix docker.socket for systemd

## v2.9.5

- bumping docker-api gem

## v2.9.4

- Switch to the dockerd binary on 1.12+
- Add links to resources overview list

## v2.9.3

- add uts_mode support for docker_container provider (#730)

## v2.9.2

- adding feature ReadonlyRootfs
- bumping docker version to 1.11.2
- removing etcd, fails tests for xenial and swarm will have it builtin in 1.12

## v2.9.1

- implement userns_mode for containers

## v2.9.0

- Feature - docker_installation_tarball resource
- Patch - Adding missing http_proxy support to rhel/sysvinit
- Patch #705 - Avoid installing docker-api gem in ChefSpec

## v2.8.0

- Feature - User namespace configuration capability for docker_service

## v2.7.1

- Updated test matrix in the readme to reflect reality

## v2.7.0

- Initial support for Ubuntu 16.04
- Initial support for Fedora 22 / 23

## v2.6.8

- notifies need to restart service immediately to prevent containers from stopping
- bumping docker-api version 1.28.0
- adding tests for image load

## v2.6.7

- only wait for running state if detached
- updating systemd template and bugfix for socket

## v2.6.6

- refactor of docker-wait-ready

## v2.6.5

- need a guard around docker_socket incase it isn't set

## v2.6.4

- passing parsed socket file to init script
- removing unused action remove_link

## v2.6.3

- Implements load action for images

## v2.6.2

- Include init support for oracle platform

## v2.6.1

- Add support for docker_container image property with custom repository port
- Resolve restarting container races
- New resource docker_exec

## v2.6.0

- :insecure_registry in the docker_service provider can now be a string or array
- scientific and oracle have been added to the metadata as supported platforms
- The effect of -1 on memory_swap has been clarified in the readme
- Tests have been updated to run faster using trap vs. nc
- Checksums for new Docker releases have been added

## v2.5.9

- Depend on compat_resource >= 12.9.0

## v2.5.8

- Setting desired_state: true for volumes / binds properties
- Now redeploy container on volume change.
- Change :restart action behavior to :run containers if they don't exist yet.

## v2.5.7

- Remove vendored gems in favor of chef_gem install
- Extending available log_driver options

## v2.5.6

- Adding no_proxy to Upstart defaults template

## v2.5.5

- Fixing up various default: nil warnings

## v2.5.4

- Allowing nil as type possibility for docker_service :package_options
- property

## v2.5.3

- Adding ChefSpec.define_matcher for all resources

## v2.5.2

- Setting log_driver and log_opts to desired_state: false

## v2.5.1

- package_options property to pass options to underlying package resource

## v2.5.0

- Defaulting installation version to 1.10.0
- Documenting docker_network resource in README
- Documenting docker_volume resource in README

## v2.4.26

- Adding docker_volume resource

## v2.4.25

- Various fixes to docker_network around subsequent runs
- Utilizing property coersion and converge_if_changed

## v2.4.24

- Avoiding restart loops in chef-client 12.4.3
- Using delayed notifications for service restarts

## v2.4.23

- Getting rid of Chef 13 deprecation warning
- returning nil in default_tls_cert_path

## v2.4.22

- Revamped systemd resources to use package native unit files
- Using /etc/systemd/system to override settings

## v2.4.21

- Revamped sysvinit resources to use package native scripts.a
- Using /etc/sysconfig on rhel and /etc/default on Debian
- Ubuntu 12.04 now uses Upstart
- Debian Wheezy support
- Fixed install_method validation

## v2.4.20

- Temporarily disabling validate_install_method

## v2.4.19

- Adding docker_tag force property

## v2.4.18

- Fixing broken version / install_method validation check

## v2.4.17

- Re-doing service_manager_upstart implementation
- Using package native init config and utilizing /etc/default

## v2.4.16

- Adding validation proc for docker_service.version to throw error
- when specifying version with script installations

## v2.4.15

- fixing raiseure -> failure typo in docker_container validation
- Patching vendored docker-api-1.26.0
- <https://github.com/swipely/docker-api/issues/369>

## v2.4.14

- Updating .gitignore and re-adding vendored docker-api gem

## v2.4.13

- stricter conditionals on container validation
- updating vendored docker-api gem to 1.26.0
- setting default Docker installation version to 1.9.1
- updating inspec for service-execute
- updating inspec for service-sysvinit
- updating inspec for service-upstart
- updating inspec for service-systemd
- removing unused serverspec suites

## v2.4.12

- Set default docker_container.exposed_port to empty Hash

## v2.4.11

- Updating metadata to use compat_resource ~> 12.7.1

## v2.4.10

- (re)adding host property to docker_network

## v2.4.9

- using require_relative to load files
- specifying resource_name instead of use_automatic_resource_name

## v2.4.8

- removing duplicate :tls properties
- removing instances of 'default: nil'
- depending on 'compat_resource', '~> 12.5.26'

## v2.4.7

- Using Gem::Version to handle semantic verisoning and be compatible for ≥ 1.10
- v2.4.6

--------------------------------------------------------------------------------

- 613 - Fix docker_container redeploys with bad link array ordering

## v2.4.5

- Fix coerce_volumes in case current value is a Chef::Node::ImmutableArray
- Adding tests for binds alias to volumes

## v2.4.4

- Updating vendored docker-api to 1.25.0
- Adding experimental docker_network resource

## v2.4.3

- Setting docker_container property defaults to match Docker CLI
- Reverting image-id hack
- Adding disable-legacy-registry

## v2.4.2

- Unifying volumes and binds properties on docker_container resource
- Should use "volumes" everywhere now. Aliased method for backward compatibility.

## v2.4.1

- Various fixes in wait-ready loops:
- 598 - systemd manager return value check for docker-wait-ready
- 600 - execute manager last iteration check fix.

## v2.4.0

- Adding support for pid_mode and ipc_mode to docker_container

## v2.3.23

- Changing bridge property validation to String

## v2.3.22

- using parsed_hostname to force nil value to Docker API when
- network_mode is host

## v2.3.21

- reverting hostname coerce

## v2.3.20

- adding coerce_hostname
- Fixing github issues #542 and #572

## v2.3.19

switching systemd unit MountFlags from slave to private

## v2.3.18

- removing detach/autoremove conflict check

## v2.3.17

- Reverting gem loading trickery. Reverting to LOAD_PATH.push

## v2.3.16

- Adding validation checking for detach / autoremove property
- conflicts

## v2.3.15

- Loading vendored gems the same way chef_gem would.
- Resolving Chef provisioning conflicts

## v2.3.14

- Supporting Upstart for Linux Mint

## v2.3.13

- Updating compat_resource dep to >=12.5.23

## v2.3.12

- Pinning compat_resource version to 12.5.14 to avoid warning

## v2.3.11

- Using LOAD_PATH.push instead of LOAD_PATH.unshift for vendored gems

## v2.3.10

- Fix method name for pidfile in docker_service_manager_execute

## v2.3.9

- Adding Linux Mint to helpers_installation_package

## v2.3.8

- 582 using symbols in excon opts
- Resolves 458

## v2.3.7

- 574 - updating docker to 1.9.1
- 575 - remove nil values from container create hash
- 576 - updating centos to 7.1
- 577 - check for conflicting properties
- 578 - Update docker_container library documentation on timeouts
- 579 - suggest adding kill_after on a failed action stop

## v2.3.6

- 573 adding support for port range

## v2.3.5

- fixing desired_state on docker_container force property

## v2.3.4

- Fixing up ports logic
- Supporting multiple ip/ports

## v2.3.3

- vendoring docker-api-1.24.1

## v2.3.2

- vendoring docker-api-1.24.0
- setting desired_state:false for tls properties

## v2.3.1

- Support for multiple docker_service instances with docker_service_manager_upstart
- Support for multiple docker_service instances with docker_service_manager_systemd

## v2.3.0

- Support for multiple docker_service instances with docker_service_manager_sysvinit

## v2.2.11

- Support for multiple docker_service instances with docker_service_manager_execute

## v2.2.10

- 565 - Add support for --exec-opt to docker daemon
- 566 - Rename cluster-opts to cluster-opt

## v2.2.9

- 560 - Add cluster-store options to docker daemon

## v2.2.8

- 559 - setting tls and tls_verify should to nil by default

## v2.2.7

- Supporting Docker ENV variables without explicitly setting
- per-resource host TLS information
- Serverspec -> inspec fixes

## v2.2.6

- Docker 1.9 support
- Updates to pull_image id checking
- Updates default_network_mode calculation

## v2.2.5

- Updating metadata to depend on compat_resource >= 12.5.14

## v2.2.4

- More minor fixes to Upstart script template

## v2.2.3

- Minor fix to Upstart script template

## v2.2.2

- Upstart script now waits for all filesystems instead of just local-filesystems

## v2.2.1

- marking attach_ properties desired_state: false

## v2.2.0

- Switching docker_installation method to auto
- Cleaning up some old Chef::Provider namespace cruft

## v2.1.23

- Adding docker_service auto_restart property. Defaulting to false.

## v2.1.22

- Updating README with docker_installation and docker_service_manager resources
- Adding "desired_state: false" to docker_installation properties

## v2.1.21

- Refactoring docker_service into docker_service_manager_whatever
- Fixing bug in coerce_daemon_labels
- Fixes to resources-171 suite serverspec

## v2.1.20

- Fixing docker_installation_script resource

## v2.1.19

- Various cruft cleanup in service templates.
- Explicitly enabling ipv4 forwarding in execute provider
- docker_service_sysvinit test suite
- docker_service_upstart test suite
- docker_service_systemd test suite

## v2.1.18

- Kitchen refactoring
- docker_service_execute bug fixes

## v2.1.17

- Fixing merge meant for v2.1.16

## v2.1.16

- Adding install_method property to select docker_installation resource
- Using docker_installation_binary by default
- Fixing up serverspec for pre-182 resource test recipes

## v2.1.15

- Updates to README around kill_after property on :stop action
- Updates to various test containers to handle SIGKILL properly

## v2.1.14

- Fixing missing property regression in docker_service

## v2.1.13

- Fixing up independent of docker_installation_binary resource, adding
- kitchen suites and serverspec tests

## v2.1.12

- 531 - Bugfix for invalid parameters in docker_container :stop
- action

## v2.1.11

- Fixing LocalJumpError in docker_container

## v2.1.10

- Adding 'desired_state: false' to various timeouts

## v2.1.9

- Refactoring: Moving remote file installation method into
- docker_installation_binary resource

## v2.1.8

- Refactoring: Removing classes from the Chef::Resource namespace

## v2.1.7

- Fixing connection information in docker_container and helpers_base
- Refactoring .kitchen.yml tests

## v2.1.6

- Enabling TLS options for docker_container and docker_image
- Various test fixes

## v2.1.5

- 528 - Don't enable https connection scheme if not using TLS

## v2.1.4

- 517 - Disallowing nil value for Docker command

## v2.1.3

- 514 - Fixing coerce and comparison logic in exposed_ports and
- volumes to prevent unwanted restarts

## v2.1.2

- Adding why_run support

## v2.1.1

- 511 - fix container wait state checking
- 512 - wait for registry ports to be open in test recipe
- 519 - updating README to include labels#511 - fix container

## v2.1.0

- Changing docker_container default action to :run from
- :run_if_missing.

## v2.0.4

- 504 - stop and start should wait for the container to complete
- 506 - restart to use the api endpoint

## v2.0.3

- Allowing nil for docker_registry properties

## v2.0.2

- Fixing LocalJumpError caused by next instead of return helper methods

## v2.0.1

- 491 - Return best host for docker to connect
- 495 - iptables opts shouldn't be forced to true/false
- 497 - Removing property_is_set so timeout pick up defaults

## v2.0.0

- Converted resources from LWRP to Chef 12.5 Custom Resources
- Added dependency on compat_resource cookbook, works back to 12.0.0
- Various fixes around sysvinit scripts in docker_service
- Total backwards compatibility with recipes written for chef-docker 1.x

## v1.0.49

- Handling NilClass error on docker_image default creds handling

## v1.0.48

- Adding a 20 try timeout to the docker_wait_ready block

## v1.0.47

- 484 - Fall back to creds for index.docker.io on image pull

## v1.0.46

- 438 - Adding per-resource host property to docker_image and
- docker_container

## v1.0.45

- Allow :redeploy on missing containers
- TLS fixes
- Updating sysvinit script to use docker_opts

## v1.0.44

- Adding Label support for docker_container

## v1.0.43

- Switching docker_service sysvinit provider from ::Insserv to ::Debian

## v1.0.42

- Fix for docker_service to allow setting icc to false
- Get chefspec happy on latest nightly chefdk again
- Accepting both String and Array for default_ulimit

## v1.0.41

- Refactoring broken sysvinit scripts
- 421 - Adding docker-wait-ready blocks
- Discovered TLS verification is broken. Disabling for now.

## v1.0.40

- Fixing broken Chef::Provider::DockerService::Execute

## v1.0.39

- Various fixes around sysvinit

## v1.0.38

- docker_container - enabling Docker CLI syntax for ulimits

## v1.0.37

- Adding tests for #416

## v1.0.36

- Replacing docker_log helper function with docker_service.logfile

## v1.0.35

- Creating DockerHelpers::Service namespace and moving appropriate methods into it.
- Start of load_current_resource implementation for docker_service for #423

## v1.0.34

- notifying new_resource to restart when updating docker_bin

## v1.0.33

- Registry authentication fixes and slight docker_image refactor
- Updates for foodcritic and travis

## v1.0.32

- 451 Changed default docker_container memory_swap to prevent unwanted redeploys.

## v1.0.31

- 447 - Fix for log-config driver type
- 448 - Fix unwanted redeploys due to calculation of exposed_port changes.
- 450 - Treat docker_container volumes attribute as unmanaged to prevent redeploys

## v1.0.30

- 427 - Qualify port bindings with protocol even when implicitly tcp.
- 443 - Added docker_container log_driver and log_opts attributes.
- Changing docker_image read_timeout default to 60
- Misc cleanup for README and Gemfile

## v1.0.29

- 432 Fixing :redeploy so it returns the container the correct state
- (create vs run)
- Fixing blank variable interpolation in tmpfiles.d/docker.conf

## v1.0.28

- Adding journald gelf and fluentd to logging driver whitelist
- Allow specifying multiple DNS servers for docker_service

## v1.0.27

- Cleaning up code duplication across docker_service init templates

## v1.0.26

- switching from get.docker.io to get.docker.com

## v1.0.25

- Updating checksum in specs for 1.8.2
- Downloading over https
- Removing nonexistent action :enable from docker_service

## v1.0.24

- 410 - Fixing Dockerfile override behavior for hostname and ulimits
- on api 1.9
- Upgrading to Docker 1.8.2 for default version

## v1.0.23

- Fixing Dockerfile / resource override behavior for working_dir

## v1.0.22

- Removed patch authentication header to bundled docker-api gem
- Moved credential reset logic into image provider

## v1.0.21

- 379 and #356 - patching vendored docker-api gem authentication headers

## v1.0.20

- Handling the situation where USER COMMAND ENV and ENTRYPOINT are set in
- an image build, but not in a docker_container resource

## v1.0.19

- Raising error on authentication error in docker_registry
- Allowing an array for storage_opts in docker_service
- Fixing parsed_checksum in docker_service
- Fixing entrypoint parsing in docker_container

## v1.0.18

- Removing leftover log resources used for debugging in development

## v1.0.17

- Fixing up regressions in older Docker API versions introduced in cookbook release 1.0.15
- Adding @api_version instance variable
- Adding serialized_log_config
- Adding parsed_network_mode

## v1.0.16

- Adding CIDR support for docker_service bip property

## v1.0.15

- 309 - Adding bits to enable container re-deployment when properties change

## v1.0.14

- Adding api read and write timeouts

## v1.0.13

- Fixing docker_service CLI argument generation for log-driver mtu and pidfile

## v1.0.12

- Fixing platform_family string (redhat -> rhel) in docker_service sysvinit provider

## v1.0.11

- Renaming retries to api_retries to not conflict with Chef::Resource

## v1.0.10

- Accepting userland-proxy flag
- Fix bug in parsed_storage_driver method
- Correcting usage of ip_forwarding flag
- Let Docker pick --log-level instead of defaulting to :info

## v1.0.9

- Fixing Upstart respawn limit

## v1.0.8

- 382 - Fixing docker_service to accept an array for storage_opt

## v1.0.7

- 381 - Removing prepended whitespace in DOCKER_OPTS

## v1.0.6

- 369 - Fixing up HostConfig.NetworkMode to work as expected

## v1.0.5

- 241 - Only updating docker_image resource on :pull if new bits were pulled
- on tag (useful for latest)
- Changing docker_image default action to :pull

## v1.0.4

- 368 - Fixing port property to be kind_of [String, Array]
- Adding missing detach property. Defaulting to false.

## v1.0.3

- 366 - Using docker_kernel instead of docker_arch in parsed_checksum

## v1.0.2

- 365 - Fix logic for parsing an array of hosts
- 363 - Allow an array for port property

## v1.0.1

- Switching docker_service default TLS setting to false to it works
- out of the box

## v1.0.0

- vendoring the docker-api rubygem
- docker_image and docker_container resources now use speak to the
- Docker Remote API instead of shelling out
- docker_containers must now have unique names
- "volumes" property now acts like the VOLUMES directive in a Dockerfile
- added "binds" property for local mounting
- standardizing on "repo" and "tag" as components of an image
- identifier

## v0.43.0 (2015-07-28)

- Updating README to reflect docker_image and docker_tag reality
- Implementing rm, noprune, nocache and force on docker_image

## v0.42.0 (2015-07-28)

- removing docker_image :load and :tag action
- adding docker_tag resource
- renaming docker_tag image_name property to :repo; creating alias
- implementing docker_image :push action

## v0.41.0 (2015-07-26)

- vendoring docker-api rubygem
- beginning work to convert docker_image to use native API instead of shelling out
- changing docker_image default action to :pull_if_missing
- removing some deprecated interfaces

## v0.40.3 (2015-07-14)

- remove --no-trunc from docker container status in sysvinit script
- 334 - docker_container tag property (issue 320)
- 331 - docker_container ulimit property
- 328 - Upstart job respawn status detection
- 326 - Upstart job restart behavior fix sysvinit script examples
- 236 - README#324 - Reference DOCKER_OPTS Amazon Linux#325

## v0.40.2 (2015-07-14)

- Support for older Chef versions

## v0.40.1 (2015-07-08)

- Changing host property to kind_of Array

## v0.40.0 (2015-06-29)

Important changes with this release:

- MAJOR INTERFACE CHANGE
- Recipes replaced with docker_service resource*
- Removing a ton of dependencies
- Storage backends, kernel module loading, etc should now be handled externally
- Updating for Docker 1.6.2
- Preferring binary install method to OS packages

IMPORTANT

- attributes/ will be removed in the next release.
- most are currently non-functional
- All options will be driven through resource properties

## v0.37.0

Please note some important changes with this release:

- The sysconfig DOCKER_OPTS improvement in [#250] can potentially change the behavior of that environment variable as it now allows shell interpolation of any embedded variables. This should not affect most environments. If your DOCKER_OPTS does contains any expected `$`, please escape via `\$` for previous behavior or be sure it will behave as expected before upgrading.
- The daemon restart option (which is deprecated) has been defaulted to `nil` instead of `false` when `node['docker']['container_init_type']` is set to prevent issues with container restart policies. If you're dependent on the daemon option, please be sure to update your `node['docker']['restart']` appropriately.
- This release also defaults systemd docker host to `fd://` to match upstream, enabling socket activation properly. Adjust `node['docker']['host']` if necessary.
- Bugfix: [#239]: Upstart: install inotify tools only once (avoid CHEF-3694 warning) (thanks jperville)
- Bugfix: [#240]: Fixed dead service containers not being restarted on docker_container :run (thanks jperville)
- Bugfix: [#244]: Made docker_container action :remove remove the actual upstart service file (thanks jperville)
- Bugfix: [#246]: Lengthen shell_out timeout as workaround for slow docker_container action stop (thanks jperville)
- Bugfix: [#258]: Fix checking docker container status on debian (thanks fxposter)
- Bugfix: [#260]: Fix accidental port changing when using systemd templates (thanks fxposter)
- Bugfix: [#266]: Get tests working on master (thanks tduffield)
- Bugfix: [#267]: Replace outdated testcontainerd (thanks tduffield)
- Bugfix: [#269]: Fix tests on Travis by following Rubocop style guidelines (container LWRP) (thanks fxposter)
- Bugfix: [#280] / [#281]: Fix port handling when omitted in container LWRP (thanks databus23)
- Bugfix: [#284] / [#285]: runit finish script to stop a container (thanks xmik)
- Bugfix: [#288][]: Fix docker.socket unit for RHEL7 (thanks databus23)
- Bugfix: [#292]: readme formatting fix (thanks wormzer)
- Improvement: [#208]: Add CentOS/RHEL 7 support (thanks dermusikman and intoximeters)
- Improvement: [#232]: Added support for insecure-registry docker daemon option (thanks jperville)
- Improvement: [#233] / [#234]: Added support for registry-mirror docker daemon option (thanks jperville and tarnfeld)
- Improvement: [#237]: Deprecate the restart daemon option (thanks jperville)
- Improvement: [#238]: Added docker_container restart attribute (thanks jperville)
- Improvement: [#242]: Added docker_container action :create (thanks jperville)
- Improvement: [#245]: Add a Gitter chat badge to README.md (thanks tduffield)
- Improvement: [#250]: Use double-quotes for DOCKER_OPTS (thanks rchekaluk)
- Improvement: [#259]: Use registry on image inspection (thanks fxposter)
- Improvement: [#263]: Add additional_host attribute to container resource (thanks fxposter)
- Improvement: [#264] / [#265]: Access keyserver.ubuntu.com on port 80 (thanks sauraus)
- Improvement: [#268]: Updated the /etc/init/docker.conf template (thanks jperville)
- Improvement: [#276]: Added support for docker options device and cap-add (thanks hvolkmer)
- Improvement: [#279]: Allow docker_container memory to have String value (eg. memory='1G') (thanks jperville)
- Improvement: [#287]: redhat 7 does not need the epel repository (thanks databus23)
- Improvement: [#289]: Update systemd service/socket files (from upstream) (thanks databus23)
- Improvement: [#296]: Default systemd to fd:// as well as use upstream MountFlags=slave and LimitCORE=infinity
- Improvement: [#297]: Update docker daemon SysV init scripts with upstream improvements
- Improvement: [#298]: Further deprecate daemon restart flag by default, which interferes with restart policies

# 0.36.0

- Bugfix: [#181]: Fixed remove_link action (thanks jperville).
- Bugfix: [#185]: Fix for non idempotent run action on docker_container (thanks bplunkert).
- Bugfix: [#188]: Applied temporary workaround to address the libcgmanager error to users running LXC on Ubuntu 14.04.
- Bugfix: [#196]: Address Helpers module naming conflict (thanks sethrosenblum).
- Bugfix: [#200]: Fix how service actions are handled by docker_container resource (thanks brianhartsock).
- Bugfix: [#202]: Correctly check for the kernel.release version on Debian (thanks Tritlo, paweloczadly).
- Bugfix: [#203]: Fix pull notifications for tagged images (thanks hobofan).
- Bugfix: [#205]: Fix current_resource.name assignments in docker_container provider (thanks jperville).
- Bugfix: [#206]: Fixes to container name detection (thanks jperville).
- Enhancement: [#217]: Explicitly set key and keyserver for docker apt repository (thanks sethrosenblum).
- Improvement: Pull in init script changes from upstream for sysv and systemd.
- Bugfix: [#219]: Explicitly set Upstart provider for Ubuntu 14.04 and 14.10 (thanks methodx).
- Improvement: [#220]: Create graph directory if it is specified (thanks jontg).
- Bugfix: [#224]: Fix runit container template to properly use exec (thanks waisbrot).
- Bugfix: Appropriately check for LXC when using the binary recipe on Fedora.
- Bugfix: Implement workaround for docker/docker#2702 on Ubuntu 14.10.
- Enhancement: [#221]: Added NO_PROXY support (thanks jperville).
- Various Test Suite Modifications

  - Enhancement: [#192]: Allow image tags in serverspec matching (thanks bplunkert).
  - Bugfix: [#223]: Convert a few occurrences of old 'should' rspec syntax to 'expect' (thanks jperville).
  - Disable a few platforms that are experiencing bugs unrelated to core functionality.
  - Address ChefSpec 4.1 deprecation warnings.
  - Update Berksfile to reference supermarket.getchef.com instead of api.berkshelf.com

# 0.35.2

- Bugfix: [#171]: Default Ubuntu 14.04 to Docker PPA
- Bugfix: [#175]: Do not set --selinux-enabled in opts unless explicitly defined for older versions
- Bugfix: [#176]: Use docker host attribute in docker_container Upstart inotifywait

# 0.35.1

- Bugfix: [#172]: Generate no cidfile by default, even when deploying as service
- Bugfix: [#173]: Updated docker upstart script (should fix service docker restart)

# 0.35.0

After a long personal hiatus (sorry!), this is the last minor release before 1.0 of the cookbook. If you can handle the Docker port number change and don't use anything deprecated, upgrading to 1.0.X from 0.35.X of the cookbook should be very easy.

This release has a bunch of changes and hasn't been fully tested yet. Wanted to get it out there for broad testing. Please use caution!

Major kudos to @tduffield for the [#147] PR, which includes:

- Binary Installation

  - Added missing dependency resolution for using the binary.

- Dependency Checks

  - Added `docker::dep_check` that will take an action if certain dependencies are not met.

    - `node[docker][alert_on_error_action] = :fatal` will kill the chef run and print the error message.
    - `node[docker][alert_on_error_action] = :warn` will print the error message but continue with the chef run. There is no guarantee that it will succeed though.

- KitchenCI

  - Copied MiniTests to ServerSpec Tests
  - Added new platforms (Debian 7.4)
  - Changed provisioner from chef-solo to chef-zero
  - Removed Ubuntu 12.10 because it is not supported by Docker and the Kernel is bad and fails all the tests.
  - Removed tests for the source recipe. The dotcloud/docker repo actually doesn't build any Go deliverables.

    - I think that the source recipe needs to be completely refactored.

Other awesome work merged:

- [#142]: Bugfix: Redeploy breaks when a link is present
- [#139]/[#153]/[#154]/[#156]/[#157]: Bugfix: container/image ID given as nil, fixes deprecated -notrunc
- [#164]: Bugfix: Removing a container should also remove its cidfile
- [#166]: Bugfix: Fix docker_inspect_id for Docker 1.0+
- [#158]/[#160]/[#165]: Bugfix: Fix NameError when displaying error messages for timed-out commands
- [#169]: Bugfix: Specify Upstart as service provider for cgroup on Ubuntu 14.04 (workaround for CHEF-5276, fixed in Chef 11.14)
- [#137]/[#138]: Enhancement: Experimental Ubuntu 14.04 LTS support
- [#144]: Enhancement: Experimental Amazon linux support
- [#150]/[#152]: Enhancement: Add net attribute, deprecate networking
- [#168]: Enhancement: Allow override of package name
- [#161]: Enhancement: Add minitest case for SysV service
- [#149]: Enhancement: Add --selinux-enabled daemon flag
- Enhancement: container LWRP remove_link and remove_volume actions
- Enhancement: Add storage-opt daemon flag
- Enhancement: Add Docker 0.11.0, 0.11.1, 0.12.0, 1.0.0, 1.0.1 binary checksums

# 0.34.2

- [#141]: Bugfix/Enhancement: Fix and enhance docker_image pull/push behavior with Docker 0.10

  - Removes deprecated --registry and --tag CLI args from docker_image pull
  - Adds support for registry attribute usage in docker_image pull and push
  - Adds support for tag attribute usage in docker_image push

# 0.34.1

- [#134]: Bugfix: Fix docker_registry login handling, fixes #114

# 0.34.0

Attributes now available for all docker daemon flags as well as system IP forwarding.

- REMOVED: container_dns_ attributes (use replacement dns_ attributes on daemon for all containers or docker_container dns* attributes instead)
- DEPRECATED: bind_* attributes to match docker terminology (use host attribute instead)
- Bugfix: [#132]: Do Not Explicitly Set storage_driver Attribute
- Bugfix: [#133]: Remove explicit false defaults in resources
- Bugfix: [#114]: Error executing action login on resource docker_registry
- Enhancement: [#115]: Add IP forwarding attributes
- Enhancement: [#116]: Docker 0.10.0: Add --no-prune to docker rmi
- Enhancement: [#117]: Docker 0.10.0: Add --output flag to docker save (as well as tag support)
- Enhancement: [#118]: Docker 0.10.0: Add --input flag to docker load
- Enhancement: [#119]: Docker 0.10.0: Add support for --env-file to load environment variables from files
- Enhancement: [#120]: Docker 0.10.0: Deprecate docker insert
- Enhancement: [#123]: Add docker kill --signal
- Enhancement: [#124]: Add all docker daemon options as attributes
- Enhancement: [#125]: Use dns* attributes to set docker daemon options, not defaults per-container
- Enhancement: [#128]: Add checksum attribute for binary downloads
- Enhancement: [#126]: Set long option names for specified docker daemon options
- Enhancement: [#127]: Use a helper function to specify single line docker daemon options

# 0.33.1

- Bugfix: [#112]: Defines runner methods for ChefSpec matchers
- Bugfix: [#113]: [D-15] Fedora 19 installs Docker 0.8.1, does not have the -G or -e flag

# 0.33.0

This release deprecates AUFS/device-mapper handling from chef-docker, but provides backwards compatibility by still including the default recipe of the new cookbooks. Please update your dependencies, Github watching/issues, and recipes to reflect the two new community cookbooks:

- aufs: [aufs on community site](http://community.opscode.com/cookbooks/aufs) / [chef-aufs on Github](https://github.com/bflad/chef-aufs)
- device-mapper: [device-mapper on community site](http://community.opscode.com/cookbooks/device-mapper) / [chef-device-mapper on Github](https://github.com/bflad/chef-device-mapper)
- Bugfix: [#109]: Remove on lxc-net start from docker Upstart
- Enhancement: [#88]: Migrate AUFS logic to separate cookbook
- Enhancement: [#90]: Migrate device-mapper logic to separate cookbook
- Enhancement: [#110]: Add docker Upstart pre-start script and limits configuration
- Enhancement: [#105]: Add --label for docker run
- Enhancement: [#106]: Add --opt for docker run
- Enhancement: [#107]: Add --networking for docker run
- Enhancement: [#108]: Add --dns-search for docker run
- Enhancement: [#104]: Add TMPDIR
- Enhancement: [#111]: Add DOCKER_LOGFILE configuration
- Enhancement: container_dns* attributes to set --dns and --dns-search for all containers

# 0.32.2

- Bugfix: [#101]: Explicitly install lxc on Ubuntu (when lxc is exec_driver; continue to fully support LXC as a default installation path since its been since Docker 0.1)
- Bugfix: [#103]: Fix host argument (in docker run)

# 0.32.1

- Bugfix: [#98]: Ensure Ruby 1.8 syntax is supported
- Bugfix: Skip empty Array values in cli_args helper

# 0.32.0

_If you're using CentOS/RHEL with EPEL, upcoming docker-io 0.9.0 package upgrade can be tracked at [Bugzilla 1074880](https://bugzilla.redhat.com/show_bug.cgi?id=1074880)_

This release includes Docker 0.9.0 changes and defaults, such as setting exec_driver to libcontainer ("native"), setting -rm on docker build, double dash arguments on the CLI, additional flags, etc.

- DEPRECATED: Rename storage_type attribute to storage_driver to [match Docker terminology](http://docs.docker.io/en/latest/reference/commandline/cli/#daemon) (storage_type will be removed in chef-docker 1.0)
- DEPRECATED: Rename virtualization_type attribute to exec_driver to [match Docker terminology](http://docs.docker.io/en/latest/reference/commandline/cli/#daemon) (virtualization_type will be removed in chef-docker 1.0)
- Bugfix: [#80]: Use double dashed arguments on CLI
- Bugfix: Surround String values on CLI with quotes
- Enhancement: [#77]: Improved docker ps handling
- Enhancement: [#78]: Docker 0.9.0: Make --rm the default for docker build
- Enhancement: [#81]: Docker 0.9.0: Add a -G option to specify the group which unix sockets belong
- Enhancement: [#82]: Docker 0.9.0: Add -f flag to docker rm to force removal of running containers
- Enhancement: Add -f flag for docker rmi to force removal of images
- Enhancement: [#83]: Docker 0.9.0: Add DOCKER_RAMDISK environment variable to make Docker work when the root is on a ramdisk
- Enhancement: [#84]: Docker 0.9.0: Add -e flag for execution driver
- Enhancement: [#85]: Docker 0.9.0: Default to libcontainer
- Enhancement: [#86]: Add Chefspec LWRP matchers

# 0.31.0

Lots of init love this release. Now supporting runit.

Please note change of storage_type attribute from devmapper to devicemapper (and associated recipe name change) to match docker's name for the driver.

Cookbook now automatically adds -s option to init configurations if storage_type is defined, which is it by default. If you were specifying -s in the options attribute, you no longer need to do so. In my quick testing, docker daemon doesn't seem to mind if -s is specified twice on startup, although you'll probably want to get rid of the extra specification.

I've also dropped the LANG= and LC_ALL= locale environment settings from the Upstart job configuration. Its not specified in the default docker job. Please open an issue in docker project and here if for some reason this is actually necessary.

- Bugfix: Match devicemapper storage_type attribute to match docker driver name (along with recipe name)
- Enhancement: [#72]: Add initial runit init_type
- Enhancement: [#60]: Automatically set docker -d -s from storage_type attribute
- Enhancement: Simplify default/sysconfig file into one template (docker.sysconfig.erb) and source into SysV/Upstart init configurations
- Enhancement: Add Debian docker daemon SysV init template

# 0.30.2

- Bugfix: [#68]: Fix CommandTimeout handling in LWRPs
- Bugfix: [#67]: Fix argument order to pull when tag specified

# 0.30.1

Public or private registry login should now correctly occur and login once per credentials change.

- Bugfix: [#64]: Correct CLI ordering of registry login
- Bugfix: [#65]: login command skipped in registry provider
- Enhancement: registry provider current resource attributes loaded from .dockercfg

# 0.30.0

Awesome work by [@jcrobak] to close out two issues ([#49] and [#52]) with [#62]. Note change below in image build action.

- Bugfix: [#52]: return codes of docker commands not verified
- Bugfix: Add missing pull_if_missing action to image resource
- Enhancement: [#56]: Switch build action to build_if_missing, build action now builds each run (be careful with image growth!)
- Enhancement: [#59]: Add Mac OS X installation support
- Enhancement: [#49]: Add docker_cmd_timeout attribute and daemon verification
- Enhancement: [#58]: Add container redeploy action
- Enhancement: [#63]: Add group_members attribute and group recipe to manage docker group

# 0.29.0

- Enhancement: [#57]: Implement id checking when determining current_resource

  - Added to both container and image LWRPs

- Enhancement: Set created and status attributes for current container resources (for handlers, wrappers, etc.)

- Enhancement: Set created and virtual_size attributes for image resource (for handlers, wrappers, etc.)

# 0.28.0

- Enhancement: [#55]: image LWRP pull action now attempts pull every run (use pull_if_missing action for old behavior)

# 0.27.1

- Bugfix: [#51]: container LWRP current_resource attribute matching should also depend on container_name

# 0.27.0

- Enhancement: [#48]: Accept FalseClass CLI arguments (also explicitly declare =true for TrueClass CLI arguments)

# 0.26.0

- Bugfix: Add SysV init script for binary installs
- Enhancement: Add storage_type and virtualization_type attributes
- Enhancement: Initial devmapper support for binary installs on CentOS/Ubuntu
- Enhancement: [#47] Debian-specific container SysV init script
- Enhancement: [#46] Add rm attribute for build action on image LWRP
- Enhancement: Add no_cache attribute for build action on image LWRP

# 0.25.1

- Bugfix: [#44] Add missing run attribute for commit action on container LWRP

# 0.25.0

- DEPRECATED: image LWRP dockerfile, image_url, and path attributes (replaced with source attribute)
- Bugfix: Use docker_cmd for container LWRP remove and restart actions
- Enhancement: Add registry LWRP with login action
- Enhancement: Standardize on "smart" and reusable destination and source attributes for container and image LWRPs to define paths/URLs for various operations
- Enhancement: Add commit, cp, export, and kill actions to container LWRP
- Enhancement: Add insert, load, push, save, and tag actions to image LWRP
- Enhancement: Add local file and directory support to import action of image LWRP
- Enhancement: Add Array support to container LWRP link attribute
- Enhancement: Cleaned up LWRP documentation

# 0.24.2

- Bugfix: [#43] Better formatting for container LWRP debug logging

# 0.24.1

- Bugfix: Explicitly declare depends and supports in metadata
- Bugfix: Handle container run action if container exists but isn't running

# 0.24.0

- Bugfix: [#42] fix(upstart): Install inotify-tools if using upstart
- Enhancement: [#38] Allow a user to specify a custom template for their container init configuration

# 0.23.1

- Bugfix: [#39] Fix NoMethodError bugs in docker::aufs recipe

# 0.23.0

- Bugfix: Default oracle init_type to sysv
- Enhancement: Experimental Debian 7 package support
- Enhancement: Use new yum-epel cookbook instead of yum::epel recipe
- Enhancement: Use `value_for_platform` where applicable in attributes, requires Chef 11

# 0.22.0

- Enhancement: [#35] Use kernel release for package name on saucy and newer
- Enhancement: [#37] dont include aufs recipe on ubuntu 13.10 and up; don't require docker::lxc for package installs

# 0.21.0

- Enhancement: [#31] More helpful cmd_timeout error messages and catchable exceptions for container (`Chef::Provider::Docker::Container::CommandTimeout`) and image (`Chef::Provider::Docker::Image::CommandTimeout`) LWRPs

# 0.20.0

- Enhancement: Default to package install_type only on distros with known packages
- Enhancement: Initial Oracle 6 platform support via binary install_type

  - <https://blogs.oracle.com/wim/entry/oracle_linux_6_5_and>
  - <http://www.oracle.com/technetwork/articles/servers-storage-admin/resource-controllers-linux-1506602.html>

- Enhancement: Split out lxc recipe for default platform lxc handling

- Enhancement: Create cgroups recipe for default platform cgroups handling

# 0.19.1

- Bugfix: [#30] apt-get throws exit code 100 when upgrading docker

# 0.19.0

- Enhancement: Add `node['docker']['version']` attribute to handle version for all install_type (recommended you switch to this)
- Enhancement: `default['docker']['binary']['version']` attribute uses `node['docker']['version']` if set
- Enhancement: Add version handling to package recipe

# 0.18.1

- Bugfix: Remove ExecStartPost from systemd service to match change in docker-io-0.7.0-13

# 0.18.0

- Enhancement: CentOS/RHEL 6 package support via EPEL repository
- Enhancement: Fedora 19/20 package support now in updates (stable) repository
- Enhancement: sysv recipe and init_type

# 0.17.0

- Removed: configuration recipe (see bugfix below)
- Removed: config_dir attribute (see bugfix below)
- Bugfix: Revert back to specifying HTTP_PROXY and "DOCKER_OPTS" natively in systemd/Upstart (mostly to fix up systemd support)
- Bugfix: Add systemctl --system daemon-reload handling to systemd service template
- Bugfix: Add || true to container systemd/Upstart pre-start in case already running
- Bugfix: Locale environment already handled automatically by systemd
- Enhancement: Switch Fedora package installation from goldmann-docker to Fedora updates-testing repository
- Enhancement: Switch container LWRPs to named containers on Fedora since now supported
- Enhancement: Update docker systemd service contents from docker-io-0.7.0-12.fc20

  - Add: Wants/After firewalld.service
  - Add: ExecStartPost firewall-cmd
  - Remove: ExecStartPost iptables commands

# 0.16.0

- Bugfix: Remove protocol from docker systemd ListenStreams
- Bugfix: Lengthen shell_out timeout for stop action in container LWRP to workaround Fedora being slow
- Enhancement: Add service creation to container LWRP by default

  - Please thoroughly test before putting into production!
  - `set['docker']['container_init_type'] = false` or add `init_type false` for the LWRP to disable this behavior

- Enhancement: Add configuration recipe with template

- Enhancement: Add container_cmd_timeout attribute to easily set global container LWRP cmd_timeout default

- Enhancement: Add image_cmd_timeout attribute to easily set global image LWRP cmd_timeout default

- Enhancement: Add cookbook attribute to container LWRP

- Enhancement: Add init_type attribute to container LWRP

- Enhancement: Add locale support for Fedora

- Enhancement: Fail Chef run if `docker run` command errors

# 0.15.0

- Enhancement: Fedora 19/20 package support via [Goldmann docker repo](http://goldmann.fedorapeople.org/repos/docker/)
- Enhancement: docker.service / docker.socket systemd support
- Enhancement: Add `node['docker']['init_type']` attribute for controlling init system

# 0.14.0

- Bugfix: [#27] Only use command to determine running container if provided
- Bugfix: [#28] Upstart requires full stop and start of service instead of restart if job configuration changes while already running. Note even `initctl reload-configuration` isn't working as expected from <http://upstart.ubuntu.com/faq.html#reload>
- Enhancement: [#26] Add ability to set package action

# 0.13.0

- Bugfix: Move LWRP updated_on_last_action(true) calls so only triggered when something actually gets updated
- Enhancement: Add container LWRP wait action
- Enhancement: Add attach and stdin args to container LWRP start action
- Enhancement: Add link arg to container LWRP remove action
- Enhancement: Use cmd_timeout in container LWRP stop action arguments

# 0.12.0

- Bugfix: Add default bind_uri (nil) to default attributes
- Enhancement: [#24] bind_socket attribute added

# 0.11.0

- DEPRACATION: container LWRP Fixnum port attribute: use full String notation from Docker documentation in port attribute instead
- DEPRACATION: container LWRP public_port attribute: use port attribute instead
- Enhancement: Additional container LWRP attributes:

  - cidfile
  - container_name
  - cpu_shares
  - dns
  - expose
  - link
  - lxc_conf
  - publish_exposed_ports
  - remove_automatically
  - volumes_from

- Enhancement: Support Array in container LWRP attributes:

  - env
  - port
  - volume

# 0.10.1

- Bugfix: Set default cmd_timeout in image LWRP to 300 instead of 60 because downloading images can take awhile
- Enhancement: Change docker_test Dockerfile FROM to already downloaded busybox image instead of ubuntu
- Enhancement: Add vagrant-cachier to Vagrantfile

Other behind the scenes changes:

- Made cookbook code Rubocop compliant
- Move licensing information to LICENSE file
- Updated .travis.yml and Gemfile

# 0.10.0

- Enhancement: [#22] cmd_timeout, path (image LWRP), working_directory (container LWRP) LWRP attributes
- Bugfix: [#25] Install Go environment only when installing from source

# 0.9.1

- Fix to upstart recipe to not restart service constantly (only on initial install and changes)

# 0.9.0

- image LWRP now supports non-stdin build and import actions (thanks [@wingrunr21]!)

# 0.8.1

- Fix in aufs recipe for FC048 Prefer Mixlib::ShellOut

# 0.8.0

Lots of community contributions this release -- thanks!

- image LWRP now supports builds via Dockerfile
- Additional privileged, public_port, and stdin parameters for container LWRP
- Support specifying binary version for installation
- Fix upstart configuration customization when installing via Apt packages
- Default to Golang 1.1

# 0.7.1

- Use HTTPS for Apt repository

# 0.7.0

- Update APT repository information for Docker 0.6+

# 0.6.2

- Change Upstart config to start on runlevels [2345] instead of just 3

# 0.6.1

- Change env HTTP_PROXY to export HTTP_PROXY in Upstart configuration

# 0.6.0

- Add bind_uri and options attributes

# 0.5.0

- Add http_proxy attribute

# 0.4.0

- Docker now provides precise/quantal/raring distributions for their PPA
- Tested Ubuntu 13.04 support

# 0.3.0

- Initial `container` LWRP

# 0.2.0

- Initial `image` LWRP

# 0.1.0

- Initial release

[#101]: https://github.com/bflad/chef-docker/issues/101
[#103]: https://github.com/bflad/chef-docker/issues/103
[#104]: https://github.com/bflad/chef-docker/issues/104
[#105]: https://github.com/bflad/chef-docker/issues/105
[#106]: https://github.com/bflad/chef-docker/issues/106
[#107]: https://github.com/bflad/chef-docker/issues/107
[#108]: https://github.com/bflad/chef-docker/issues/108
[#109]: https://github.com/bflad/chef-docker/issues/109
[#110]: https://github.com/bflad/chef-docker/issues/110
[#111]: https://github.com/bflad/chef-docker/issues/111
[#112]: https://github.com/bflad/chef-docker/issues/112
[#113]: https://github.com/bflad/chef-docker/issues/113
[#114]: https://github.com/bflad/chef-docker/issues/114
[#115]: https://github.com/bflad/chef-docker/issues/115
[#116]: https://github.com/bflad/chef-docker/issues/116
[#117]: https://github.com/bflad/chef-docker/issues/117
[#118]: https://github.com/bflad/chef-docker/issues/118
[#119]: https://github.com/bflad/chef-docker/issues/119
[#120]: https://github.com/bflad/chef-docker/issues/120
[#123]: https://github.com/bflad/chef-docker/issues/123
[#124]: https://github.com/bflad/chef-docker/issues/124
[#125]: https://github.com/bflad/chef-docker/issues/125
[#126]: https://github.com/bflad/chef-docker/issues/126
[#127]: https://github.com/bflad/chef-docker/issues/127
[#128]: https://github.com/bflad/chef-docker/issues/128
[#132]: https://github.com/bflad/chef-docker/issues/132
[#133]: https://github.com/bflad/chef-docker/issues/133
[#134]: https://github.com/bflad/chef-docker/issues/134
[#137]: https://github.com/bflad/chef-docker/issues/137
[#138]: https://github.com/bflad/chef-docker/issues/138
[#139]: https://github.com/bflad/chef-docker/issues/139
[#141]: https://github.com/bflad/chef-docker/issues/141
[#142]: https://github.com/bflad/chef-docker/issues/142
[#144]: https://github.com/bflad/chef-docker/issues/144
[#147]: https://github.com/bflad/chef-docker/issues/147
[#149]: https://github.com/bflad/chef-docker/issues/149
[#150]: https://github.com/bflad/chef-docker/issues/150
[#152]: https://github.com/bflad/chef-docker/issues/152
[#153]: https://github.com/bflad/chef-docker/issues/153
[#154]: https://github.com/bflad/chef-docker/issues/154
[#156]: https://github.com/bflad/chef-docker/issues/156
[#157]: https://github.com/bflad/chef-docker/issues/157
[#158]: https://github.com/bflad/chef-docker/issues/158
[#160]: https://github.com/bflad/chef-docker/issues/160
[#161]: https://github.com/bflad/chef-docker/issues/161
[#164]: https://github.com/bflad/chef-docker/issues/164
[#165]: https://github.com/bflad/chef-docker/issues/165
[#166]: https://github.com/bflad/chef-docker/issues/166
[#168]: https://github.com/bflad/chef-docker/issues/168
[#169]: https://github.com/bflad/chef-docker/issues/169
[#171]: https://github.com/bflad/chef-docker/issues/171
[#172]: https://github.com/bflad/chef-docker/issues/172
[#173]: https://github.com/bflad/chef-docker/issues/173
[#175]: https://github.com/bflad/chef-docker/issues/175
[#176]: https://github.com/bflad/chef-docker/issues/176
[#181]: https://github.com/bflad/chef-docker/issues/181
[#185]: https://github.com/bflad/chef-docker/issues/185
[#188]: https://github.com/bflad/chef-docker/issues/188
[#192]: https://github.com/bflad/chef-docker/issues/192
[#196]: https://github.com/bflad/chef-docker/issues/196
[#200]: https://github.com/bflad/chef-docker/issues/200
[#202]: https://github.com/bflad/chef-docker/issues/202
[#203]: https://github.com/bflad/chef-docker/issues/203
[#205]: https://github.com/bflad/chef-docker/issues/205
[#206]: https://github.com/bflad/chef-docker/issues/206
[#208]: https://github.com/bflad/chef-docker/issues/208
[#217]: https://github.com/bflad/chef-docker/issues/217
[#219]: https://github.com/bflad/chef-docker/issues/219
[#22]: https://github.com/bflad/chef-docker/issues/22
[#220]: https://github.com/bflad/chef-docker/issues/220
[#221]: https://github.com/bflad/chef-docker/issues/221
[#223]: https://github.com/bflad/chef-docker/issues/223
[#224]: https://github.com/bflad/chef-docker/issues/224
[#232]: https://github.com/bflad/chef-docker/issues/232
[#233]: https://github.com/bflad/chef-docker/issues/233
[#234]: https://github.com/bflad/chef-docker/issues/234
[#237]: https://github.com/bflad/chef-docker/issues/237
[#238]: https://github.com/bflad/chef-docker/issues/238
[#239]: https://github.com/bflad/chef-docker/issues/239
[#24]: https://github.com/bflad/chef-docker/issues/24
[#240]: https://github.com/bflad/chef-docker/issues/240
[#242]: https://github.com/bflad/chef-docker/issues/242
[#244]: https://github.com/bflad/chef-docker/issues/244
[#245]: https://github.com/bflad/chef-docker/issues/245
[#246]: https://github.com/bflad/chef-docker/issues/246
[#25]: https://github.com/bflad/chef-docker/issues/25
[#250]: https://github.com/bflad/chef-docker/issues/250
[#258]: https://github.com/bflad/chef-docker/issues/258
[#259]: https://github.com/bflad/chef-docker/issues/259
[#26]: https://github.com/bflad/chef-docker/issues/26
[#260]: https://github.com/bflad/chef-docker/issues/260
[#263]: https://github.com/bflad/chef-docker/issues/263
[#264]: https://github.com/bflad/chef-docker/issues/264
[#265]: https://github.com/bflad/chef-docker/issues/265
[#266]: https://github.com/bflad/chef-docker/issues/266
[#267]: https://github.com/bflad/chef-docker/issues/267
[#268]: https://github.com/bflad/chef-docker/issues/268
[#269]: https://github.com/bflad/chef-docker/issues/269
[#27]: https://github.com/bflad/chef-docker/issues/27
[#276]: https://github.com/bflad/chef-docker/issues/276
[#279]: https://github.com/bflad/chef-docker/issues/279
[#28]: https://github.com/bflad/chef-docker/issues/28
[#280]: https://github.com/bflad/chef-docker/issues/280
[#281]: https://github.com/bflad/chef-docker/issues/281
[#284]: https://github.com/bflad/chef-docker/issues/284
[#285]: https://github.com/bflad/chef-docker/issues/285
[#287]: https://github.com/bflad/chef-docker/issues/287
[#289]: https://github.com/bflad/chef-docker/issues/289
[#292]: https://github.com/bflad/chef-docker/issues/292
[#296]: https://github.com/bflad/chef-docker/issues/296
[#297]: https://github.com/bflad/chef-docker/issues/297
[#298]: https://github.com/bflad/chef-docker/issues/298
[#30]: https://github.com/bflad/chef-docker/issues/30
[#31]: https://github.com/bflad/chef-docker/issues/31
[#35]: https://github.com/bflad/chef-docker/issues/35
[#37]: https://github.com/bflad/chef-docker/issues/37
[#38]: https://github.com/bflad/chef-docker/issues/38
[#39]: https://github.com/bflad/chef-docker/issues/39
[#42]: https://github.com/bflad/chef-docker/issues/42
[#43]: https://github.com/bflad/chef-docker/issues/43
[#44]: https://github.com/bflad/chef-docker/issues/44
[#46]: https://github.com/bflad/chef-docker/issues/46
[#47]: https://github.com/bflad/chef-docker/issues/47
[#48]: https://github.com/bflad/chef-docker/issues/48
[#49]: https://github.com/bflad/chef-docker/issues/49
[#51]: https://github.com/bflad/chef-docker/issues/51
[#52]: https://github.com/bflad/chef-docker/issues/52
[#55]: https://github.com/bflad/chef-docker/issues/55
[#56]: https://github.com/bflad/chef-docker/issues/56
[#57]: https://github.com/bflad/chef-docker/issues/57
[#58]: https://github.com/bflad/chef-docker/issues/58
[#59]: https://github.com/bflad/chef-docker/issues/59
[#60]: https://github.com/bflad/chef-docker/issues/60
[#62]: https://github.com/bflad/chef-docker/issues/62
[#63]: https://github.com/bflad/chef-docker/issues/63
[#64]: https://github.com/bflad/chef-docker/issues/64
[#65]: https://github.com/bflad/chef-docker/issues/65
[#67]: https://github.com/bflad/chef-docker/issues/67
[#68]: https://github.com/bflad/chef-docker/issues/68
[#72]: https://github.com/bflad/chef-docker/issues/72
[#77]: https://github.com/bflad/chef-docker/issues/77
[#78]: https://github.com/bflad/chef-docker/issues/78
[#80]: https://github.com/bflad/chef-docker/issues/80
[#81]: https://github.com/bflad/chef-docker/issues/81
[#82]: https://github.com/bflad/chef-docker/issues/82
[#83]: https://github.com/bflad/chef-docker/issues/83
[#84]: https://github.com/bflad/chef-docker/issues/84
[#85]: https://github.com/bflad/chef-docker/issues/85
[#86]: https://github.com/bflad/chef-docker/issues/86
[#88]: https://github.com/bflad/chef-docker/issues/88
[#89]: https://github.com/bflad/chef-docker/issues/89
[#90]: https://github.com/bflad/chef-docker/issues/90
[#91]: https://github.com/bflad/chef-docker/issues/91
[#98]: https://github.com/bflad/chef-docker/issues/98
[@jcrobak]: https://github.com/jcrobak
[@wingrunr21]: https://github.com/wingrunr21
