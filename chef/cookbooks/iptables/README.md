# iptables Cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/iptables.svg?branch=master)](https://travis-ci.org/chef-cookbooks/iptables) [![Cookbook Version](https://img.shields.io/cookbook/v/iptables.svg)](https://supermarket.chef.io/cookbooks/iptables)

Installs iptables and provides a custom resource for adding and removing iptables rules

## Requirements

### Platforms

- Ubuntu/Debian
- RHEL/CentOS and derivatives
- Amazon Linux

### Chef

- Chef 12.10+

### Cookbooks

- none

## Recipes

### default

The default recipe will install iptables and provides a ruby script (installed in `/usr/sbin/rebuild-iptables`) to manage rebuilding firewall rules from files dropped off in `/etc/iptables.d`.

### disabled

The disabled recipe will install iptables, disable the `iptables` service (on RHEL platforms), and delete the rules directory `/etc/iptables.d`.

## Attributes

`default['iptables']['iptables_sysconfig']` and `default['iptables']['ip6tables_sysconfig']` are hashes that are used to template /etc/sysconfig/iptables-config and /etc/sysconfig/ip6tables-config. The keys must be upper case and any key / value pair included will be added to the config file.

`default['iptables']['system_ruby']` allows users to override the system ruby path if ruby is installed into a non standard location and Chef has been installed without an embedded ruby (eg. from the Gem).

## Custom Resource

### rule

The custom resource drops off a template in `/etc/iptables.d` after the `name` parameter. The rule will get added to the local system firewall through notifying the `rebuild-iptables` script. See **Examples** below.

NOTE: In the 1.0 release of this cookbook the iptables_rule definition was converted to a custom resource. This changes the behavior of disabling iptables rules. Previously a rule could be disabled by specifying `enable false`. You must now specify `action :disable`

## Usage

Add `recipe[iptables]` to your runlist to ensure iptables is installed / running and to ensure that the `rebuild-iptables` script is on the system. Then create use iptables_rule to add individual rules. See **Examples**.

Since certain chains can be used with multiple tables (e.g., _PREROUTING_), you might have to include the name of the table explicitly (i.e., _*nat_, _*mangle_, etc.), so that the `/usr/sbin/rebuild-iptables` script can infer how to assemble final ruleset file that is going to be loaded. Please note, that unless specified otherwise, rules will be added under the **filter** table by default.

### Examples

To enable port 80, e.g. in an `my_httpd` cookbook, create the following template:

```text
# Port 80 for http
-A FWR -p tcp -m tcp --dport 80 -j ACCEPT
```

This template would be located at: `my_httpd/templates/default/http.erb`. Then within your recipe call:

```ruby
iptables_rule 'http' do
  action :enable
end
```

To redirect port 80 to local port 8080, e.g., in the aforementioned `my_httpd` cookbook, create the following template:

```text
*nat
# Redirect anything on eth0 coming to port 80 to local port 8080
-A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
```

Please note, that we explicitly add name of the table (being _*nat_ in this example above) where the rules should be added.

This would most likely go in the cookbook, `my_httpd/templates/default/http_8080.erb`. Then to use it in `recipe[httpd]`:

```ruby
iptables_rule 'http_8080' do
  action :enable
end
```

To create a rule without using a template resource use the `lines` property (you can optionally specify `table` when using `lines`):

```ruby
iptables_rule 'http_8080' do
  lines '-A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080'
  table :nat
end
```

Additionally, a rule can be marked as sensitive so it's contents does not get output to the the console or logged with the sensitive property set to `true`. The mode of the generated rule file can be set with the filemode property:

```ruby
iptables_rule 'http_8080' do
  lines '-A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080'
  table :nat
  sensitive true
end
```

```ruby
iptables_rule 'http_8080' do
  lines '-A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080'
  table :nat
  sensitive true
  filemode '0600'
end
```

To get attribute-driven rules you can (for example) feed a hash of attributes into named iptables.d files like this:

```ruby
node.default['iptables']['rules']['http_80'] = '-A FWR -p tcp -m tcp --dport 80 -j ACCEPT'
node.default['iptables']['rules']['http_443'] = [
  '# an example with multiple lines',
  '-A FWR -p tcp -m tcp --dport 443 -j ACCEPT',
]

node['iptables']['rules'].map do |rule_name, rule_body|
  iptables_rule rule_name do
    lines [ rule_body ].flatten.join("\n")
  end
end
```

## IPv6 supports

The `iptables_rule6` provides IPv6 support with the same behavior as the original `iptable_rule`.

A `/usr/sbin/rebuild-ip6tables` script perform iptables configuration and the IPv6 rules are stored in `/etc/ip6tables.d`

## License & Authors

**Author:** Cookbook Engineering Team ([cookbooks@chef.io](mailto:cookbooks@chef.io))

**Copyright:** 2008-2018, Chef Software, Inc.

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
