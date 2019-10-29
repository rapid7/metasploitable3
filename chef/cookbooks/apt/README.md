# apt Cookbook

[![Build Status](https://img.shields.io/travis/chef-cookbooks/apt.svg)][travis] [![Cookbook Version](https://img.shields.io/cookbook/v/apt.svg)][cookbook]

This cookbook includes recipes to execute apt-get update to ensure the local APT package cache is up to date. There are recipes for managing the apt-cacher-ng caching proxy and proxy clients. It also includes a custom resource for pinning packages via /etc/apt/preferences.d.

## Requirements

### Platforms

- Ubuntu 12.04+
- Debian 7+

May work with or without modification on other Debian derivatives.

### Chef

- Chef 13.3+

### Cookbooks

- None

## Recipes

### default

This recipe manually updates the timestamp file used to only run `apt-get update` if the cache is more than one day old.

This recipe should appear first in the run list of Debian or Ubuntu nodes to ensure that the package cache is up to date before managing any `package` resources with Chef.

This recipe also sets up a local cache directory for preseeding packages.

**Including the default recipe on a node that does not support apt (such as Windows or RHEL) results in a noop.**

### cacher-client

Configures the node to use a `apt-cacher-ng` server to cache apt requests. Configuration of the server to use is located in `default['apt']['cacher_client']['cacher_server']` which is a hash containing `host`, `port`, `proxy_ssl`, and `bypass` keys. Example:

```json
{
    "apt": {
        "cacher_client": {
            "cacher_server": {
                "host": "cache_server.mycorp.dmz",
                "port": 1234,
                "proxy_ssl": true,
                "cache_bypass": {
                    "download.oracle.com": "http"
                }
            }
        }
    }
}
```

#### Bypassing the cache

Occasionally you may come across repositories that do not play nicely when the node is using an `apt-cacher-ng` server. You can configure `cacher-client` to bypass the server and connect directly to the repository with the `cache_bypass` attribute.

To do this, you need to override the `cache_bypass` attribute with an hash of repositories, with each key as the repository URL and value as the protocol to use:

```json
{
    "apt": {
        "cacher_client": {
            "cacher_server": {
                "cache_bypass": {
                    "URL": "PROTOCOL"
                }
            }
        }
    }
}
```

For example, to prevent caching and directly connect to the repository at `download.oracle.com` via http and the repo at `nginx.org` via https

```json
{
    "apt": {
        "cacher_client": {
            "cacher_server": {
                "cache_bypass": {
                    "download.oracle.com": "http",
                    "nginx.org": "https"
                }
            }
        }
    }
}
```

### cacher-ng

Installs the `apt-cacher-ng` package and service so the system can provide APT caching. You can check the usage report at <http://{hostname}:3142/acng-report.html>.

If you wish to help the `cacher-ng` recipe seed itself, you must now explicitly include the `cacher-client` recipe in your run list **after** `cacher-ng` or you will block your ability to install any packages (ie. `apt-cacher-ng`).

### unattended-upgrades

Installs and configures the `unattended-upgrades` package to provide automatic package updates. This can be configured to upgrade all packages or to just install security updates by setting `['apt']['unattended_upgrades']['allowed_origins']`.

To pull just security updates, set `origins_patterns` to something like `["origin=Ubuntu,archive=trusty-security"]` (for Ubuntu trusty) or `["origin=Debian,label=Debian-Security"]` (for Debian).

## Attributes

### General

- `['apt']['compile_time_update']` - force the default recipe to run `apt-get update` at compile time.
- `['apt']['periodic_update_min_delay']` - minimum delay (in seconds) between two actual executions of `apt-get update` by the `execute[apt-get-update-periodic]` resource, default is '86400' (24 hours)

### Caching

- `['apt']['cacher_client']['cacher_server']` - Hash containing server information used by clients for caching. See the example in the recipes section above for the full format of the hash.
- `['apt']['cacher_interface']` - interface to connect to the cacher-ng service, no default.
- `['apt']['cacher_port']` - port for the cacher-ng service (used by server recipe only), default is '3142'
- `['apt']['cacher_dir']` - directory used by cacher-ng service, default is '/var/cache/apt-cacher-ng'
- `['apt']['compiletime']` - force the `cacher-client` recipe to run before other recipes. It forces apt to use the proxy before other recipes run. Useful if your nodes have limited access to public apt repositories. This is overridden if the `cacher-ng` recipe is in your run list. Default is 'false'

### Unattended Upgrades

- `['apt']['unattended_upgrades']['enable']` - enables unattended upgrades, default is false
- `['apt']['unattended_upgrades']['update_package_lists']` - automatically update package list (`apt-get update`) daily, default is true
- `['apt']['unattended_upgrades']['allowed_origins']` - array of allowed apt origins from which to pull automatic upgrades, defaults to a guess at the system's main origin and should almost always be overridden
- `['apt']['unattended_upgrades']['origins_patterns']` - array of allowed apt origin patterns from which to pull automatic upgrades, defaults to none.
- `['apt']['unattended_upgrades']['package_blacklist']` - an array of package which should never be automatically upgraded, defaults to none
- `['apt']['unattended_upgrades']['auto_fix_interrupted_dpkg']` - attempts to repair dpkg state with `dpkg --force-confold --configure -a` if it exits uncleanly, defaults to false (contrary to the unattended-upgrades default)
- `['apt']['unattended_upgrades']['minimal_steps']` - Split the upgrade into the smallest possible chunks. This makes the upgrade a bit slower but it has the benefit that shutdown while a upgrade is running is possible (with a small delay). Defaults to false.
- `['apt']['unattended_upgrades']['install_on_shutdown']` - Install upgrades when the machine is shuting down instead of doing it in the background while the machine is running. This will (obviously) make shutdown slower. Defaults to false.
- `['apt']['unattended_upgrades']['mail']` - Send email to this address for problems or packages upgrades. Defaults to no email.
- `['apt']['unattended_upgrades']['sender']` - Send email from this address for problems or packages upgrades. Defaults to 'root'.
- `['apt']['unattended_upgrades']['mail_only_on_error']` - If set, email will only be set on upgrade errors. Otherwise, an email will be sent after each upgrade. Defaults to true.
- `['apt']['unattended_upgrades']['remove_unused_dependencies']` Do automatic removal of new unused dependencies after the upgrade. Defaults to false.
- `['apt']['unattended_upgrades']['automatic_reboot']` - Automatically reboots _without confirmation_ if a restart is required after the upgrade. Defaults to false.
- `['apt']['unattended_upgrades']['dl_limit']` - Limits the bandwidth used by apt to download packages. Value given as an integer in kb/sec. Defaults to nil (no limit).
- `['apt']['unattended_upgrades']['random_sleep']` - Wait a random number of seconds up to this value before running daily periodic apt actions. System default is 1800 seconds (30 minutes).
- `['apt']['unattended_upgrades']['syslog_enable']` - Enable logging to syslog. Defaults to false.
- `['apt']['unattended_upgrades']['syslog_facility']` - Specify syslog facility. Defaults to 'daemon'.
- `['apt']['unattended_upgrades']['dpkg_options']` An array of dpkg options to be used specifically only for unattended upgrades. Defaults to `[]` which will prevent it from being rendered from the template in the resulting file.

### Configuration for APT

- `['apt']['confd']['force_confask']` - Prompt when overwriting configuration files. (default: false)
- `['apt']['confd']['force_confdef']` - Don't prompt when overwriting configuration files. (default: false)
- `['apt']['confd']['force_confmiss']` - Install removed configuration files when upgrading packages. (default: false)
- `['apt']['confd']['force_confnew']` - Overwrite configuration files when installing packages. (default: false)
- `['apt']['confd']['force_confold']` - Keep modified configuration files when installing packages. (default: false)
- `['apt']['confd']['install_recommends']` - Consider recommended packages as a dependency for installing. (default: true)
- `['apt']['confd']['install_suggests']` - Consider suggested packages as a dependency for installing. (default: false)

## Libraries

There is an `interface_ipaddress` method that returns the IP address for a particular host and interface, used by the `cacher-client` recipe. To enable it on the server use the `['apt']['cacher_interface']` attribute.

## Usage

Put `recipe[apt]` first in the run list. If you have other recipes that you want to use to configure how apt behaves, like new sources, notify the execute resource to run, e.g.:

```ruby
template '/etc/apt/sources.list.d/my_apt_sources.list' do
  notifies :run, 'execute[apt-get update]', :immediately
end
```

The above will run during execution phase since it is a normal template resource, and should appear before other package resources that need the sources in the template.

Put `recipe[apt::cacher-ng]` in the run_list for a server to provide APT caching and add `recipe[apt::cacher-client]` on the rest of the Debian-based nodes to take advantage of the caching server.

If you want to cleanup unused packages, there is also the `apt-get autoclean` and `apt-get autoremove` resources provided for automated cleanup.

## Resources

### apt_preference

The apt_preference resource has been moved into chef-client in Chef 13.3.

See <https://docs.chef.io/resource_apt_preference.html> for usage details

### apt_repository

The apt_repository resource has been moved into chef-client in Chef 12.9.

See <https://docs.chef.io/resource_apt_repository.html> for usage details

### apt_update

The apt_update resource has been moved into chef-client in Chef 12.7.

See <https://docs.chef.io/resource_apt_update.html> for usage details

## Maintainers

This cookbook is maintained by Chef's Community Cookbook Engineering team. Our goal is to improve cookbook quality and to aid the community in contributing to cookbooks. To learn more about our team, process, and design goals see our [team documentation](https://github.com/chef-cookbooks/community_cookbook_documentation/blob/master/COOKBOOK_TEAM.MD). To learn more about contributing to cookbooks like this see our [contributing documentation](https://github.com/chef-cookbooks/community_cookbook_documentation/blob/master/CONTRIBUTING.MD), or if you have general questions about this cookbook come chat with us in #cookbok-engineering on the [Chef Community Slack](http://community-slack.chef.io/)

## License

**Copyright:** 2009-2017, Chef Software, Inc.

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

[cookbook]: https://community.chef.io/cookbooks/apt
[travis]: https://travis-ci.org/chef-cookbooks/apt
