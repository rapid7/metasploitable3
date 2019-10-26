# mysql Cookbook CHANGELOG

This file is used to list changes made in each version of the mysql cookbook.

## 8.5.1 (2017-08-23)

- Fix the remainder of the namespace collision deprecation warnings
- Remove the class_eval in the action class as this causes issues with some releases of Chef 12

## 8.5.0 (2017-08-23)

- Require Chef 12.7+ since 12.5/12.6 has custom resource action_class issues
- Resolve several Chef 14 deprecation warnings

## 8.4.0 (2017-05-30)

- Fix client/server install on Amazon Linux and add testing
- Remove support for Ubuntu Precise since it's EOL
- Add Amazon Linux testing

## 8.3.1 (2017-04-04)

- Fix an ignoring of 'cookbook' attribute by 'mysql_config' resource
- Remove unused helper method
- Call out the supported platform versions in the metadata
- Switch to Delivery Local and rename the docked config
- Remove mention of the EOL opensuse 13.x in the readme

## 8.3.0 (2017-03-20)
- Refactor mysql_service_manager_upstart.rb to eliminate use of cloned resource

## 8.2.0 (2016-12-03)

- Include client development packages on RHEL/SUSE platforms

## 8.1.1 (2016-10-31)
- Fixing CVE-2016-6662 - Reverting execure bit on mysql config

## 8.1.0 (2016-10-29)

- Drop hardcoded, specific package version logic that broke many users

## 8.0.4 (2016-09-26)
- Bump debian version
- Updated packages for 12.04 and 14.04 too
- Add chef_version metadata
- Update platforms in the kitchen file
- Add selinux to the Berksfile for testing
- Make sure yum repos are setup in local Test Kitchen

## 8.0.3 (2016-09-14)
- [GH-390] Fix #390 incorrect escaping of initial_root_password
- Updated package versions for Ubuntu 16.04
- Testing updates

# v8.0.2 (2016-08-25)
- Various bug fixed and updates to package version strings

# v8.0.1 (2016-07-20)
- Fixed a regression in the mysql_client resource where the action was changed from create to install in the 8.0 release
- Added oracle, opensuse, and opensuseleap as supported platforms in the metadata

# v8.0.0 (2016-07-11)

- Converting from LWRP to custom resources
- Removing yum-mysql and other dependencies.
- ^ BREAKING CHANGE: RHELish users are now responsible
  for including a recipe from the "yum-mysql" or equivalent
  cookbook before utilizing the mysql_* resources.
- More thoughtful ChefSpec
- Renaming "replication" test suite to "smoke"
- Moving to Inspec

## v7.2.0 (2016-06-30)

- Support openeSUSE leap
- Support Fedora 24

## v7.1.2 (2016-06-30)

- Avoid deprecation warnings on the upcoming Chef 12.12 release

## v7.1.1 (2016-06-03)

- Fix apparmor blocking writes to non-default tmp_dirs
- Updated apparmor config to allow read & write to sock.lock file
- Use cookstyle instead of Rubocop directly

## v7.1.0 (2016-05-11)

- Added support for Ubuntu 16.04

## v7.0.0 (2016-04-19)

- Removed support for legacy distros: Ubuntu 10.04/13.04/14.10/15.04, Fedora 20/21, OmniOS r151006, opensuse 11.3/12.0
- Added support for Fedora 23, suse 13.X, and Ubuntu 16.04
- Updated the systemd support to create unit files in /etc/systemd and not /usr/lib/systemd
- Adding umask to bash resource that sets root password PR #386 @gziskind
- Cleaned up the Test Kitchen config to test the right platform version + mysql pairings
- Added Travis CI Test Kitchen testing on Fedora 22/23 and removed Fedora 21
- Updated the platforms used in the specs

## v6.1.3 (2016-03-14)

- Added support for Ubuntu 15.10
- Added support for Amazon Linux 2016-03
- Updated Kitchen testing configs

## v6.1.2 (2015-10-05)

- Added support for Amazon Linux 2015.09

## v6.1.1 (2015-09-24)

- Completing ChefSpec matchers

## v6.1.0 (2015-07-17)

- Adding tunables for tmp_dir, error_log, and pid_file
- Adding mysqld_options hash interface for main my.cnf template

## v6.0.31 (2015-07-13)

- Reverting create_stop_system_service checks

## v6.0.30 (2015-07-13)

- Ubuntu 15.04 support
- Check for scripts and unit files during create_stop_system_service

## v6.0.29 (2015-07-12)

- Patch to allow blank root password
- Adding package information for Suse 12.0

## v6.0.28 (2015-07-10)

- Fixes for 12.4.x

## v6.0.27 (2015-07-09)

- Allowing integer value for port number

## v6.0.26 (2015-07-07)

- Reverting breaking changes introduced in 6.0.25

## v6.0.25 (2015-07-06)

- Fixes for 12.4.1

## v6.0.24 (2015-06-27)

- 341 - Changing default GRANT for root from '%' to 'localhost' and '127.0.0.1'

## v6.0.23 (2015-06-21)

- 354 Better handling of long MySQL startup times

## v6.0.22 (2015-05-07)

- Debian 8 (Jessie) support

## v6.0.21 (2015-04-08)

- Fix to Upstart prestart script when using custom socket
- Adding --explicit_defaults_for_timestamp mysql_install_db_cmd for
- 5.6 and above

## v6.0.20 (2015-03-27)

- 318 - Fixing Upstart pre-start script to handle custom socket paths

## v6.0.19 (2015-03-25)

- Adding support for Amazon Linux 2015.03

## v6.0.18 (2015-03-24)

- Adding support for 5.6 and 5.7 packages from dotdeb repos on Debian 7

## v6.0.17 (2015-03-13)

- Updated for MySQL 5.7.6.
- Handing removal of mysql_install_db and mysqld_safe

## v6.0.16 (2015-03-10)

- Moved --defaults-file as first option to mysql_install_db_script

## v6.0.15 (2015-02-26)

- Updating docker detection fix to pass specs

## v6.0.14 (2015-02-26)

- Fixed debian system service :disable action. Now survives reboot
- Fixing centos-7 instance :enable action. Now survives
- Not applying Apparmor policy if running in a Docker container

## v6.0.13 (2015-02-15)

- Adding support for special characters in initial_root_password
- Fixing failure status bug in sysvinit script

## v6.0.12 (2015-02-30)

- No changes. Released a 6.0.11 that was identical to 6.0.10.
- Git before coffee.

## v6.0.11 (2015-02-30)

- Adding support for configurable socket files

## v6.0.10 (2015-01-19)

- Fix #282 - Fixing up data_dir template variable

## v6.0.9 (2015-01-19)

- Fix #282 - undefined method `parsed_data_dir' bug

## v6.0.8 (2015-01-19)

- Refactoring helper methods out of resource classes

## v6.0.7 (2015-01-14)

- Fixing timing issue with Upstart provider :restart and :reload
- actions where service returns before being available

## v6.0.6 (2014-12-26)

- Fixing subtle bug where MysqlCookbook::Helper methods were polluting Chef::Resource

## v6.0.5 (2014-12-25)

- Using 'include_recipe' instead of 'recipe_eval' in LWRP
- Fixing type checking on package_name attribute in mysql_client resource.

## v6.0.4 (2014-12-21)

- Suggest available versions if current is not available for current platform.

## v6.0.3 (2014-12-17)

- Adding bind_address parameter to mysql_service resource

## v6.0.2 (2014-12-17)

- Fixing sysvinit provider to survive reboots

## v6.0.1 (2014-12-16)

- Fixing Upstart template to survive reboots

## v6.0.0 (2014-12-15)

- Major version update
- Cookbook now provides LWRPs instead of recipes
- Platform providers re-factored into init system providers
- Separated :create and :start actions for use in recipes that build containers
- mysql_service now supports multiple instances on the same machine
- mysql_service no longer attempts to manage user records
- Removal of debian-sys-maint
- Unified Sysvinit script that works on all platforms
- mysql_config resource introduced
- mysql_client fixed up
- Refactored acceptance tests
- Temporarily dropped FreeBSD support

## v5.6.1 (2014-10-29)

- Use Gem::Version instead of Chef::Version

## v5.6.0 (2014-10-29)

- Changing default charset to utf8
- Quoting passwords in debian.cnf.erb
- Amazon 2014.09 support
- Ubuntu 14.10 support
- Only hide passwords from STDOUT via "sensitive true" in chef-client higher than 11.14
- Updating test harness

## v5.5.4 (2014-10-07)

- Adding sensitive flag to execute resources to protect passwords from logs

## v5.5.3 (2014-09-24)

- Reverting back to Upstart on Ubuntu 14.04

## v5.5.2 (2014-09-8)

- Reverting commit that broke Debian pass_string

## v5.5.1 (2014-09-2)

- Switching Ubuntu service provider to use SysVinit instead of Upstart

## v5.5.0 (2014-08-27)

- Adding package version and action parameters to mysql_service resource
- Fixing Debian pass_string

## v5.4.4 (2014-08-27)

- Changing module namespace to MysqlCookbook

## v5.4.3 (2014-08-25)

- More refactoring. Moving helper function bits into resource parsed_parameters

## v5.4.2 (2014-08-25)

- Moving provider local variables into definitions for RHEL provider

## v5.4.1 (2014-08-25)

- Refactoring resources into the LWRP style with parsed parameters
- Moving provider local variables into definitions

## v5.4.0 (2014-08-25)

- 212 - support for centos-7 (mysql55 and mysql56)
- Adding (untested) Debian-6 support
- Adding Suse support to metadata.rb
- Adding ability to change MySQL root password
- Added libmysqlclient-devel package to SuSE client provider
- Appeasing AppArmor
- Reducing duplication in client provider

## v5.3.6 (2014-06-18)

- Fixing pid path location. Updating tests to include real RHEL

## v5.3.4 (2014-06-16)

- Fixing specs for Amazon Linux server package names

## v5.3.2 (2014-06-16)

- Fixing Amazon Linux support

## v5.3.0 (2014-06-11)

- 189 - Fix server_repl_password description
- 191 - Adding support for server55 and server56 on el-6
- 193 - Fix syntax in mysql_service example
- 199 - Adding Suse support

## v5.2.12 (2014-05-19)

PR #192 - recipes/server.rb should honor parameter node['mysql']['version']

## v5.2.10 (2014-05-15)

- COOK-4394 - restore freebsd support

## v5.2.8 (2014-05-15)

- [COOK-4653] - Missing mySQL 5.6 support for Ubuntu 14.04

## v5.2.6 (2014-05-07)

- [COOK-4625] - Fix password resource parameter consumption on Debian and Ubuntu
- Fix up typos and version numbers in PLATFORMS.md
- Fix up specs from COOK-4613 changes

## v5.2.4 (2014-05-02)

- [COOK-4613] - Fix permissions on mysql data_dir to allow global access to mysql.sock

## v5.2.2 (2014-04-24)

- [COOK-4564] - Using positive tests for datadir move

## v5.2.0 (2014-04-22)

- [COOK-4551] - power grants.sql from resource parameters

## v5.1.12 (2014-04-21)

- [COOK-4554] - Support for Debian Sid

## v5.1.10 (2014-04-21)

- [COOK-4565] Support for Ubuntu 14.04
- [COOK-4565] Adding Specs and TK platform
- Removing non-LTS 13.10 specs and TK platform

## v5.1.8 (2014-04-12)

Adding Ubuntu 13.04 to Platforminfo

## v5.1.6 (2014-04-11)

- [COOK-4548] - Add template[/etc/mysql/debian.cnf] to Ubuntu provider

## v5.1.4 (2014-04-11)

- [COOK-4547] - Shellescape server_root_password

## v5.1.2 (2014-04-09)

- [COOK-4519] - Fix error in run_dir for Ubuntu
- [COOK-4531] - Fix pid and run_dir for Debian

## v5.1.0 (2014-04-08)

[COOK-4523] - Allow for both :restart and :reload

## v5.0.6 (2014-04-07)

- [COOK-4519] - Updating specs to reflect pid file change on Ubuntu

## v5.0.4 (2014-04-07)

- [COOK-4519] - Fix path to pid file on Ubuntu

## v5.0.2 (2014-04-01)

- Moving server_deprecated into recipes directory

## v5.0.0 (2014-03-31)

- Rewriting as a library cookbook
- Exposing mysql_service and mysql_client resources
- User now needs to supply configuration
- Moving attribute driven recipe to server-deprecated

## v4.1.2 (2014-02-28)

- [COOK-4349] - Fix invalid platform check
- [COOK-4184] - Better handling of Ubuntu upstart service
- [COOK-2100] - Changing innodb_log_file_size tunable results in inability to start MySQL

## v4.1.1 (2014-02-25)

- **[COOK-2966] - Address foodcritic failures'
- **[COOK-4182] - Template parse failure in /etc/init/mysql.conf (data_dir)'
- **[COOK-4198] - Added missing tunable'
- **[COOK-4206] - create root@127.0.0.1, as well as root@localhost'

## v4.0.20 (2014-01-18)

- [COOK-3931] - MySQL Server Recipe Regression for Non-LTS Ubuntu Versions
- [COOK-3945] - MySQL cookbook fails on Ubuntu 13.04/13.10
- [COOK-3966] - mysql::server recipe can't find a template with debian 7.x
- [COOK-3985] - Missing /etc/mysql/debian.cnf template on mysql::_server_debian.rb recipe (mysql 4.0.4)
- [COOK-3974] - debian.cnf not updated
- [COOK-4001] - Pull request: Fixes for broken mysql::server on Debian
- [COOK-4071] - Mysql cookbook doesn't work on debian 7.2

## v4.0.14

Fixing style cops

## v4.0.12

### Bug

- **[COOK-4068](https://tickets.chef.io/browse/COOK-4068)** - rework MySQL Windows recipe

### Improvement

- **[COOK-3801](https://tickets.chef.io/browse/COOK-3801)** - Add innodb_adaptive_flushing_method and innodb_adaptive_checkpoint

## v4.0.10

fixing metadata version error. locking to 3.0

## v4.0.8

Locking yum dependency to '< 3'

## v4.0.6

# Bug

- [COOK-3943] Notifying service restart on grants update

## v4.0.4

[COOK-3952] - Adding 'recursive true' to directory resources

## v4.0.2

### BUGS

- Adding support for Amazon Linux in attributes/server_rhel.rb
- Fixing bug where unprivileged users cannot connect over a local socket. Adding integration test.
- Fixing bug in mysql_grants_cmd generation

## v4.0.0

- [COOK-3928] Heavily refactoring for readability. Moving platform implementation into separate recipes
- Moving integration tests from minitest to serverspec, removing "improper" tests
- Moving many attributes into the ['mysql']['server']['whatever'] namespace
- [COOK-3481] - Merged Lucas Welsh's Windows bits and moved into own recipe
- [COOK-3697] - Adding security hardening attributes
- [COOK-3780] - Fixing data_dir on Debian and Ubuntu
- [COOK-3807] - Don't use execute[assign-root-password] on Debian and Ubuntu
- [COOK-3881] - Fixing /etc being owned by mysql user

## v3.0.12

### Bug

- **[COOK-3752](https://tickets.chef.io/browse/COOK-3752)** - mysql service fails to start in mysql::server recipe

## v3.0.10

- Fix a failed release attempt for v3.0.8

## v3.0.8

### Bug

- **[COOK-3749](https://tickets.chef.io/browse/COOK-3749)** - Fix a regression with Chef 11-specific features

## v3.0.6

### Bug

- **[COOK-3674](https://tickets.chef.io/browse/COOK-3674)** - Fix an issue where the MySQL server fails to set the root password correctly when `data_dir` is a non-default value
- **[COOK-3647](https://tickets.chef.io/browse/COOK-3647)** - Fix README typo (databas => database)
- **[COOK-3477](https://tickets.chef.io/browse/COOK-3477)** - Fix log-queries-not-using-indexes not working
- **[COOK-3436](https://tickets.chef.io/browse/COOK-3436)** - Pull percona repo in compilation phase
- **[COOK-3208](https://tickets.chef.io/browse/COOK-3208)** - Fix README typo (LitenPort => ListenPort)
- **[COOK-3149](https://tickets.chef.io/browse/COOK-3149)** - Create my.cnf before installing
- **[COOK-2681](https://tickets.chef.io/browse/COOK-2681)** - Fix log_slow_queries for 5.5+
- **[COOK-2606](https://tickets.chef.io/browse/COOK-2606)** - Use proper bind address on cloud providers

### Improvement

- **[COOK-3498](https://tickets.chef.io/browse/COOK-3498)** - Add support for replicate_* variables in my.cnf

## v3.0.4

### Bug

- **[COOK-3310](https://tickets.chef.io/browse/COOK-3310)** - Fix missing `GRANT` option
- **[COOK-3233](https://tickets.chef.io/browse/COOK-3233)** - Fix escaping special characters
- **[COOK-3156](https://tickets.chef.io/browse/COOK-3156)** - Fix GRANTS file when `remote_root_acl` is specified
- **[COOK-3134](https://tickets.chef.io/browse/COOK-3134)** - Fix Chef 11 support
- **[COOK-2318](https://tickets.chef.io/browse/COOK-2318)** - Remove redundant `if` block around `node.mysql.tunable.log_bin`

## v3.0.2

### Bug

- [COOK-2158]: apt-get update is run twice at compile time
- [COOK-2832]: mysql grants.sql file has errors depending on attrs
- [COOK-2995]: server.rb is missing a platform_family comparison value

### Sub-task

- [COOK-2102]: `innodb_flush_log_at_trx_commit` value is incorrectly set based on CPU count

## v3.0.0

**Note** This is a backwards incompatible version with previous versions of the cookbook. Tickets that introduce incompatibility are COOK-2615 and COOK-2617.

- [COOK-2478] - Duplicate 'read_only' server attribute in base and tunable
- [COOK-2471] - Add tunable to set slave_compressed_protocol for reduced network traffic
- [COOK-1059] - Update attributes in mysql cookbook to support missing options for my.cnf usable by Percona
- [COOK-2590] - Typo in server recipe to do with conf_dir and confd_dir
- [COOK-2602] - Add `lower_case_table_names` tunable
- [COOK-2430] - Add a tunable to create a network ACL when allowing `remote_root_access`
- [COOK-2619] - mysql: isamchk deprecated
- [COOK-2515] - Better support for SUSE distribution for mysql cookbook
- [COOK-2557] - mysql::percona_repo attributes missing and key server typo
- [COOK-2614] - Duplicate `innodb_file_per_table`
- [COOK-2145] - MySQL cookbook should remove anonymous and password less accounts
- [COOK-2553] - Enable include directory in my.cnf template for any platform
- [COOK-2615] - Rename `key_buffer` to `key_buffer_size`
- [COOK-2626] - Percona repo URL is being constructed incorrectly
- [COOK-2616] - Unneeded attribute thread_cache
- [COOK-2618] - myisam-recover not using attribute value
- [COOK-2617] - open-files is a duplicate of open-files-limit

## v2.1.2

- [COOK-2172] - Mysql cookbook duplicates `binlog_format` configuration

## v2.1.0

- [COOK-1669] - Using platform("ubuntu") in default attributes always returns true
- [COOK-1694] - Added additional my.cnf fields and reorganized cookbook to avoid race conditions with mysql startup and sql script execution
- [COOK-1851] - Support server-id and binlog_format settings
- [COOK-1929] - Update msyql server attributes file because setting attributes without specifying a precedence is deprecated
- [COOK-1999] - Add read_only tunable useful for replication slave servers

## v2.0.2

- [COOK-1967] - mysql: trailing comma in server.rb platform family

## v2.0.0

**Important note for this release**

Under Chef Solo, you must set the node attributes for the root, debian and repl passwords or the run will completely fail. See COOK-1737 for background on this.

- [COOK-1390] - MySQL service cannot start after reboot
- [COOK-1610] - Set root password outside preseed (blocker for drop-in mysql replacements)
- [COOK-1624] - Mysql cookbook fails to even compile on windows
- [COOK-1669] - Using platform("ubuntu") in default attributes always returns true
- [COOK-1686] - Add mysql service start
- [COOK-1687] - duplicate `innodb_buffer_pool_size` attribute
- [COOK-1704] - mysql cookbook fails spec tests when minitest-handler cookbook enabled
- [COOK-1737] - Fail a chef-solo run when `server_root_password`, `server_debian_password`, and/or `server_repl_password` is not set
- [COOK-1769] - link to database recipe in mysql README goes to old chef/cookbooks repo instead of chef-cookbook organization
- [COOK-1963] - use `platform_family`

## v1.3.0

**Important note for this release**

This version no longer installs Ruby bindings in the client recipe by default. Use the ruby recipe if you'd like the RubyGem. If you'd like packages from your distribution, use them in your application's specific cookbook/recipe, or modify the client packages attribute. This resolves the following tickets:

- COOK-932
- COOK-1009
- COOK-1384

Additionally, this cookbook now has tests (COOK-1439) for use under test-kitchen.

The following issues are also addressed in this release.

- [COOK-1443] - MySQL (>= 5.1.24) does not support `innodb_flush_method` = fdatasync
- [COOK-1175] - Add Mac OS X support
- [COOK-1289] - handle additional tunable attributes
- [COOK-1305] - add auto-increment-increment and auto-increment-offset attributes
- [COOK-1397] - make the port an attribute
- [COOK-1439] - Add MySQL cookbook tests for test-kitchen support
- [COOK-1236] - Move package names into attributes to allow percona to free-ride
- [COOK-934] - remove deprecated mysql/libraries/database.rb, use the database cookbook instead.
- [COOK-1475] - fix restart on config change

## v1.2.6

- [COOK-1113] - Use an attribute to determine if upstart is used
- [COOK-1121] - Add support for Windows
- [COOK-1140] - Fix conf.d on Debian
- [COOK-1151] - Fix server_ec2 handling /var/lib/mysql bind mount
- [COOK-1321] - Document setting password attributes for solo

## v1.2.4

- [COOK-992] - fix FATAL nameerror
- [COOK-827] - `mysql:server_ec2` recipe can't mount `data_dir`
- [COOK-945] - FreeBSD support

## v1.2.2

- [COOK-826] mysql::server recipe doesn't quote password string
- [COOK-834] Add 'scientific' and 'amazon' platforms to mysql cookbook

## v1.2.1

- [COOK-644] Mysql client cookbook 'package missing' error message is confusing
- [COOK-645] RHEL6/CentOS6 - mysql cookbook contains 'skip-federated' directive which is unsupported on MySQL 5.1

## v1.2.0

- [COOK-684] remove mysql_database LWRP

## v1.0.8

- [COOK-633] ensure "cloud" attribute is available

## v1.0.7

- [COOK-614] expose all mysql tunable settings in config
- [COOK-617] bind to private IP if available

## v1.0.6

- [COOK-605] install mysql-client package on ubuntu/debian

## v1.0.5

- [COOK-465] allow optional remote root connections to mysql
- [COOK-455] improve platform version handling
- externalize conf_dir attribute for easier cross platform support
- change datadir attribute to data_dir for consistency

## v1.0.4

- fix regressions on debian platform
- [COOK-578] wrap root password in quotes
- [COOK-562] expose all tunables in my.cnf
