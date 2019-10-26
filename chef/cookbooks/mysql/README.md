# MySQL Cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/mysql.svg?branch=master)](https://travis-ci.org/chef-cookbooks/mysql) [![Cookbook Version](https://img.shields.io/cookbook/v/mysql.svg)](https://supermarket.chef.io/cookbooks/mysql)

The MySQL Cookbook is a library cookbook that provides resource primitives (LWRPs) for use in recipes. It is designed to be a reference example for creating highly reusable cross-platform cookbooks.

## Scope

This cookbook is concerned with the "MySQL Community Server", particularly those shipped with F/OSS Unix and Linux distributions. It does not address forks or value-added repackaged MySQL distributions like MariaDB or Percona.

## Requirements

- Chef 12.7 or higher
- Network accessible package repositories
- 'recipe[selinux::disabled]' on RHEL platforms

## Platform Support

The following platforms have been tested with Test Kitchen:

```
|----------------+-----+-----+-----+-----|
|                | 5.1 | 5.5 | 5.6 | 5.7 |
|----------------+-----+-----+-----+-----|
| debian-7       |     | X   |     |     |
|----------------+-----+-----+-----+-----|
| debian-8       |     | X   |     |     |
|----------------+-----+-----+-----+-----|
| ubuntu-14.04   |     | X   | X   |     |
|----------------+-----+-----+-----+-----|
| ubuntu-16.04   |     |     |     | X   |
|----------------+-----+-----+-----+-----|
| centos-6       | X   | X   | X   | X   |
|----------------+-----+-----+-----+-----|
| centos-7       |     | X   | X   | X   |
|----------------+-----+-----+-----+-----|
| fedora         |     |     | X   | X   |
|----------------+-----+-----+-----+-----|
| openSUSE Leap  |     |     | X   |     |
|----------------+-----+-----+-----+-----|
```

## Cookbook Dependencies

There are no hard coupled dependencies. However, there is a loose dependency on `yum-mysql-community` for RHEL/CentOS platforms. As of the 8.0 version of this cookbook, configuration of the package repos is now the responsibility of the user.

## Usage

Place a dependency on the mysql cookbook in your cookbook's metadata.rb

```ruby
depends 'mysql', '~> 8.0'
```

Then, in a recipe:

```ruby
mysql_service 'foo' do
  port '3306'
  version '5.5'
  initial_root_password 'change me'
  action [:create, :start]
end
```

The service name on the OS is `mysql-foo`. You can manually start and stop it with `service mysql-foo start` and `service mysql-foo stop`.

The configuration file is at `/etc/mysql-foo/my.cnf`. It contains the minimum options to get the service running. It looks like this.

```
# Chef generated my.cnf for instance mysql-foo

[client]
default-character-set          = utf8
port                           = 3306
socket                         = /var/run/mysql-foo/mysqld.sock

[mysql]
default-character-set          = utf8

[mysqld]
user                           = mysql
pid-file                       = /var/run/mysql-foo/mysqld.pid
socket                         = /var/run/mysql-foo/mysqld.sock
port                           = 3306
datadir                        = /var/lib/mysql-foo
tmpdir                         = /tmp
log-error                      = /var/log/mysql-foo/error.log
!includedir /etc/mysql-foo/conf.d

[mysqld_safe]
socket                         = /var/run/mysql-foo/mysqld.sock
```

You can put extra configuration into the conf.d directory by using the `mysql_config` resource, like this:

```ruby
mysql_service 'foo' do
  port '3306'
  version '5.5'
  initial_root_password 'change me'
  action [:create, :start]
end

mysql_config 'foo' do
  source 'my_extra_settings.erb'
  notifies :restart, 'mysql_service[foo]'
  action :create
end
```

You are responsible for providing `my_extra_settings.erb` in your own cookbook's templates folder.

## Connecting with the mysql CLI command

Logging into the machine and typing `mysql` with no extra arguments will fail. You need to explicitly connect over the socket with `mysql -S /var/run/mysql-foo/mysqld.sock`, or over the network with `mysql -h 127.0.0.1`

## Upgrading from older version of the mysql cookbook

- It is strongly recommended that you rebuild the machine from scratch. This is easy if you have your `data_dir` on a dedicated mount point. If you _must_ upgrade in-place, follow the instructions below.
- The 6.x series supports multiple service instances on a single machine. It dynamically names the support directories and service names. `/etc/mysql becomes /etc/mysql-instance_name`. Other support directories in `/var` `/run` etc work the same way. Make sure to specify the `data_dir` property on the `mysql_service` resource to point to the old `/var/lib/mysql` directory.

## Resources Overview

### mysql_service

The `mysql_service` resource manages the basic plumbing needed to get a MySQL server instance running with minimal configuration.

The `:create` action handles package installation, support directories, socket files, and other operating system level concerns. The internal configuration file contains just enough to get the service up and running, then loads extra configuration from a conf.d directory. Further configurations are managed with the `mysql_config` resource.

- If the `data_dir` is empty, a database will be initialized, and a
- root user will be set up with `initial_root_password`. If this
- directory already contains database files, no action will be taken.

The `:start` action starts the service on the machine using the appropriate provider for the platform. The `:start` action should be omitted when used in recipes designed to build containers.

#### Example

```ruby
mysql_service 'default' do
  version '5.7'
  bind_address '0.0.0.0'
  port '3306'
  data_dir '/data'
  initial_root_password 'Ch4ng3me'
  action [:create, :start]
end
```

Please note that when using `notifies` or `subscribes`, the resource to reference is `mysql_service[name]`, not `service[mysql]`.

#### Parameters

- `charset` - specifies the default character set. Defaults to `utf8`.
- `data_dir` - determines where the actual data files are kept on the machine. This is useful when mounting external storage. When omitted, it will default to the platform's native location.
- `error_log` - Tunable location of the error_log
- `initial_root_password` - allows the user to specify the initial root password for mysql when initializing new databases. This can be set explicitly in a recipe, driven from a node attribute, or from data_bags. When omitted, it defaults to `ilikerandompasswords`. Please be sure to change it.
- `instance` - A string to identify the MySQL service. By convention, to allow for multiple instances of the `mysql_service`, directories and files on disk are named `mysql-<instance_name>`. Defaults to the resource name.
- `package_action` - Defaults to `:install`.
- `package_name` - Defaults to a value looked up in an internal map.
- `package_version` - Specific version of the package to install,passed onto the underlying package manager. Defaults to `nil`.
- `bind_address` - determines the listen IP address for the mysqld service. When omitted, it will be determined by MySQL. If the address is "regular" IPv4/IPv6address (e.g 127.0.0.1 or ::1), the server accepts TCP/IP connections only for that particular address. If the address is "0.0.0.0" (IPv4) or "::" (IPv6), the server accepts TCP/IP connections on all IPv4 or IPv6 interfaces.
- `mysqld_options` - A key value hash of options to be rendered into the main my.cnf. WARNING - It is highly recommended that you use the `mysql_config` resource instead of sending extra config into a `mysql_service` resource. This will allow you to set up notifications and subscriptions between the service and its configuration. That being said, this can be useful for adding extra options needed for database initialization at first run.
- `port` - determines the listen port for the mysqld service. When omitted, it will default to '3306'.
- `run_group` - The name of the system group the `mysql_service` should run as. Defaults to 'mysql'.
- `run_user` - The name of the system user the `mysql_service` should run as. Defaults to 'mysql'.
- `pid_file` - Tunable location of the pid file.
- `socket` - determines where to write the socket file for the `mysql_service` instance. Useful when configuring clients on the same machine to talk over socket and skip the networking stack. Defaults to a calculated value based on platform and instance name.
- `tmp_dir` - Tunable location of the tmp_dir
- `version` - allows the user to select from the versions available for the platform, where applicable. When omitted, it will install the default MySQL version for the target platform. Available version numbers are `5.0`, `5.1`, `5.5`, `5.6`, and `5.7`, depending on platform.

#### Actions

- `:create` - Configures everything but the underlying operating system service.
- `:delete` - Removes everything but the package and data_dir.
- `:start` - Starts the underlying operating system service
- `:stop`- Stops the underlying operating system service
- `:restart` - Restarts the underlying operating system service
- `:reload` - Reloads the underlying operating system service

#### Providers

Chef selects the appropriate provider based on platform and version, but you can specify one if your platform support it.

```ruby
mysql_service[instance-1] do
  port '1234'
  data_dir '/mnt/lottadisk'
  provider Chef::Provider::MysqlServiceSysvinit
  action [:create, :start]
end
```

- `Chef::Provider::MysqlServiceBase` - Configures everything needed to run a MySQL service except the platform service facility. This provider should never be used directly. The `:start`, `:stop`, `:restart`, and `:reload` actions are stubs meant to be overridden by the providers below.
- `Chef::Provider::MysqlServiceSmf` - Starts a `mysql_service` using the Service Management Facility, used by Solaris and Illumos. Manages the FMRI and method script.
- `Chef::Provider::MysqlServiceSystemd` - Starts a `mysql_service` using SystemD. Manages the unit file and activation state
- `Chef::Provider::MysqlServiceSysvinit` - Starts a `mysql_service` using SysVinit. Manages the init script and status.
- `Chef::Provider::MysqlServiceUpstart` - Starts a `mysql_service` using Upstart. Manages job definitions and status.

### mysql_config

The `mysql_config` resource is a wrapper around the core Chef `template` resource. Instead of a `path` parameter, it uses the `instance` parameter to calculate the path on the filesystem where file is rendered.

#### Example

```ruby
mysql_config[default] do
  source 'site.cnf.erb'
  action :create
end
```

#### Parameters

- `config_name` - The base name of the configuration file to be rendered into the conf.d directory on disk. Defaults to the resource name.
- `cookbook` - The name of the cookbook to look for the template source. Defaults to nil
- `group` - System group for file ownership. Defaults to 'mysql'.
- `instance` - Name of the `mysql_service` instance the config is meant for. Defaults to 'default'.
- `owner` - System user for file ownership. Defaults to 'mysql'.
- `source` - Template in cookbook to be rendered.
- `variables` - Variables to be passed to the underlying `template` resource.
- `version` - Version of the `mysql_service` instance the config is meant for. Used to calculate path. Only necessary when using packages with unique configuration paths, such as RHEL Software Collections or OmniOS. Defaults to 'nil'

#### Actions

- `:create` - Renders the template to disk at a path calculated using the instance parameter.
- `:delete` - Deletes the file from the conf.d directory calculated using the instance parameter.

#### More Examples

```ruby
mysql_service 'instance-1' do
  action [:create, :start]
end

mysql_service 'instance-2' do
  action [:create, :start]
end

mysql_config 'logging' do
  instance 'instance-1'
  source 'logging.cnf.erb'
  action :create
  notifies :restart, 'mysql_service[instance-1]'
end

mysql_config 'security settings for instance-2' do
  config_name 'security'
  instance 'instance-2'
  source 'security_stuff.cnf.erb'
  variables(:foo => 'bar')
  action :create
  notifies :restart, 'mysql_service[instance-2]'
end
```

### mysql_client

The `mysql_client` resource manages the MySQL client binaries and development libraries.

It is an example of a "singleton" resource. Declaring two `mysql_client` resources on a machine usually won't yield two separate copies of the client binaries, except for platforms that support multiple versions (RHEL SCL, OmniOS).

#### Example

```ruby
mysql_client 'default' do
  action :create
end
```

#### Properties

- `package_name` - An array of packages to be installed. Defaults to a value looked up in an internal map.
- `package_version` - Specific versions of the package to install, passed onto the underlying package manager. Defaults to `nil`.
- `version` - Major MySQL version number of client packages. Only valid on for platforms that support multiple versions, such as RHEL via Software Collections and OmniOS.

#### Actions

- `:create` - Installs the client software
- `:delete` - Removes the client software

## Advanced Usage Examples

There are a number of configuration scenarios supported by the use of resource primitives in recipes. For example, you might want to run multiple MySQL services, as different users, and mount block devices that contain pre-existing databases.

### Multiple Instances as Different Users

```ruby
# instance-1
user 'alice' do
  action :create
end

directory '/mnt/data/mysql/instance-1' do
  owner 'alice'
  action :create
end

mount '/mnt/data/mysql/instance-1' do
  device '/dev/sdb1'
  fstype 'ext4'
  action [:mount, :enable]
end

mysql_service 'instance-1' do
  port '3307'
  run_user 'alice'
  data_dir '/mnt/data/mysql/instance-1'
  action [:create, :start]
end

mysql_config 'site config for instance-1' do
  instance 'instance-1'
  source 'instance-1.cnf.erb'
  notifies :restart, 'mysql_service[instance-1]'
end

# instance-2
user 'bob' do
  action :create
end

directory '/mnt/data/mysql/instance-2' do
  owner 'bob'
  action :create
end

mount '/mnt/data/mysql/instance-2' do
  device '/dev/sdc1'
  fstype 'ext3'
  action [:mount, :enable]
end

mysql_service 'instance-2' do
  port '3308'
  run_user 'bob'
  data_dir '/mnt/data/mysql/instance-2'
  action [:create, :start]
end

mysql_config 'site config for instance-2' do
  instance 'instance-2'
  source 'instance-2.cnf.erb'
  notifies :restart, 'mysql_service[instance-2]'
end
```

### Replication Testing

Use multiple `mysql_service` instances to test a replication setup. This particular example serves as a smoke test in Test Kitchen because it exercises different resources and requires service restarts.

<https://github.com/chef-cookbooks/mysql/blob/master/test/fixtures/cookbooks/mysql_replication_test/recipes/default.rb>

## Frequently Asked Questions

### How do I run this behind my firewall?

On Linux, the `mysql_service` resource uses the platform's underlying package manager to install software. For this to work behind firewalls, you'll need to either:

- Configure the system yum/apt utilities to use a proxy server that
- can reach the Internet
- Host a package repository on a network that the machine can talk to

On the RHEL platform_family, applying the `yum::default` recipe will allow you to drive the `yum_globalconfig` resource with attributes to change the global yum proxy settings.

If hosting repository mirrors, applying one of the following recipes and adjust the settings with node attributes.

- `recipe[yum-centos::default]` from the Supermarket

  <https://supermarket.chef.io/cookbooks/yum-centos>

  <https://github.com/chef-cookbooks/yum-centos>

- `recipe[yum-mysql-community::default]` from the Supermarket

  <https://supermarket.chef.io/cookbooks/yum-mysql-community>

  <https://github.com/chef-cookbooks/yum-mysql-community>

### The mysql command line doesn't work

If you log into the machine and type `mysql`, you may see an error like this one:

`Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock'`

This is because MySQL is hardcoded to read the defined default my.cnf file, typically at /etc/my.cnf, and this LWRP deletes it to prevent overlap among multiple MySQL configurations.

To connect to the socket from the command line, check the socket in the relevant my.cnf file and use something like this:

`mysql -S /var/run/mysql-foo/mysqld.sock -Pwhatever`

Or to connect over the network, use something like this: connect over the network..

`mysql -h 127.0.0.1 -Pwhatever`

These network or socket ssettings can also be put in you $HOME/.my.cnf, if preferred.

### What about MariaDB, Percona, etc.

MySQL forks are purposefully out of scope for this cookbook. This is mostly to reduce the testing matrix to a manageable size. Cookbooks for these technologies can easily be created by copying and adapting this cookbook. However, there will be differences.

Package repository locations, package version names, software major version numbers, supported platform matrices, and the availability of software such as XtraDB and Galera are the main reasons that creating multiple cookbooks to make sense.

## Maintainers

This cookbook is maintained by Chef's Community Cookbook Engineering team. Our goal is to improve cookbook quality and to aid the community in contributing to cookbooks. To learn more about our team, process, and design goals see our [team documentation](https://github.com/chef-cookbooks/community_cookbook_documentation/blob/master/COOKBOOK_TEAM.MD). To learn more about contributing to cookbooks like this see our [contributing documentation](https://github.com/chef-cookbooks/community_cookbook_documentation/blob/master/CONTRIBUTING.MD), or if you have general questions about this cookbook come chat with us in #cookbok-engineering on the [Chef Community Slack](http://community-slack.chef.io/)

## License

```text
Copyright:: 2009-2017 Chef Software, Inc

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
