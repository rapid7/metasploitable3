# compat_resource cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/compat_resource.svg?branch=master)](https://travis-ci.org/chef-cookbooks/compat_resource) [![Cookbook Version](https://img.shields.io/cookbook/v/compat_resource.svg)](https://supermarket.chef.io/cookbooks/compat_resource)

This cookbook backports functionality introduced in the latest chef-client releases to any chef-client from 12.1 onwards. This includes [Custom Resource](https://docs.chef.io/custom_resources.html) functionality, notification improvements, as well as new resources added to core chef. It allows for the usage of these new resources in cookbooks without requiring the very latest Chef client release.

## Backported functionality

- [Custom Resources](https://docs.chef.io/custom_resources.html)
- [apt_repository](https://docs.chef.io/resource_apt_repository.html)
- [apt_update](https://docs.chef.io/resource_apt_update.html)
- [systemd_unit](https://docs.chef.io/resource_systemd_unit.html)
- [yum_repository](https://docs.chef.io/resource_yum_repository.html)
- [:before notifications](https://docs.chef.io/resources.html#timers)

## Requirements

### Platforms

- All platforms supported by Chef

### Chef

- Chef 12.1+

### Cookbooks

- none

## Usage

To use this cookbook, put `depends 'compat_resource'` in the metadata.rb of your cookbook. Once this is done, you can use all the new custom resource features to define resources. It Just Works.

## Custom Resources?

Curious about how to use custom resources?

- Docs: <https://docs.chef.io/custom_resources.html>
- Slides: <https://docs.chef.io/decks/custom_resources.html>

## License & Authors

- Author:: Lamont Granquist ([lamont@chef.io](mailto:lamont@chef.io))
- Author:: John Keiser ([jkeiser@chef.io](mailto:jkeiser@chef.io))

```text
Copyright:: 2015-2016 Chef Software, Inc.

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
