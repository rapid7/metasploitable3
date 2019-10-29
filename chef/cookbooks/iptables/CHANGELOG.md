# iptables Cookbook CHANGELOG
This file is used to list changes made in each version of the iptables cookbook.

## 4.5.0 (2018-11-24)

- Add sensitive option to resources
- Added filemode property to generated rule files

## 4.4.1 (2018-09-11)

- Remove mention of matchers in the readme
- Add back support for RHEL 6 + fix Amazon Linux 2 support
- Add additional specs for the package installs so we don't break this in the future

## 4.4.0 (2018-09-10)

- Use persistent iptables package for Debian config
- Add IPv6 support to iptables_rule and Add iptables_rule6
- Extend disabled recipe for Fedora and Amazon distros

## 4.3.4 (2018-02-15)

- Fix converge failures in the custom resource introduced in 4.3.3
- Remove stove and tomlrb from the Gemfile
- use apt_update not apt cookbook in testing
- Add Amazon Linux to test kitchen
- Simplify the platform family check using our helpers

## 4.3.3 (2018-02-15)

- Don't use kind_of in the custom resource (FC117)

## 4.3.2 (2018-02-07)

- Fix FC108 to resolve test failures
- Switch from ServerSpec to InSpec
- Resolve ChefSpec warnings
- Remove ChefSpec matchers that are no longer needed since ChefSpec autogenerates these

## 4.3.1 (2017-11-06)

- Updating namespace for attribute-based rules in the readme

## 4.3.0 (2017-10-28)

- Add Amazon Linux support on Chef 13

## 4.2.1 (2017-09-08)

- Resolve deprecation warning

## 4.2.0 (2017-04-14)

- [GH-69] - Clearing out iptables rule files on RHEL with the iptables::disabled recipe

## 4.1.0 (2017-04-11)

- specify optional table property for use with lines

## 4.0.1 (2017-03-29)
- Update metadata to require Chef 12.10+ due to use of with_run_context 

## 4.0.0 (2017-02-27)

- Remove EOL platforms from testing
- Require Chef 12.5 and remove compat_resource dependency

## 3.1.0 (2017-01-16)

- Update readme to include new attribute
- Check subcmd exit codes in rebuild-iptables script
- fixed iptables disabled recipe to flush iptables after disabling the service

## 3.0.1 (2016-10-10)
- Fix rules resource so rebuild-iptables only runs once
- Add tests for nested resources
- Add system ruby attribute so that it can be overridden

## 3.0.0 (2016-09-16)
- Remove kitchen cloud config
- Fix default specs to work properly on RHEL and other general spec cleanup
- Simplify testing and fix failing tests on RHEL
- allow using a file provider instead of a template
- rename 'content' to 'lines' and add documentation
- make the attributes example a bit more useful
- using iptables-restore logic for rhel - same as debian
- copy new config to default location in case of iptables restart
- refactored rebuild-iptables script
- Update supported os
- Use compat_resource to restore Chef 12.1 - 12.4 compatibility

## v2.2.0 (2016-02-17)
- Remove the dependency on compat_resource cookbook. This fixes RHEL systems, but increases the required Chef version to 12.5 or later

## v2.1.1 (2016-01-26)
- Fixed failures on RHEL in the disabled recipe

## v2.1.0 (2016-01-25)
- Improved compatbility with Fedora
- Added management of the iptables sysconfig files using 2 new attributes. See the readme for more information

## v2.0.2 (2016-01-15)
- Fixed rules not being rebuilt when using the disable action in the custom resource

## v2.0.1 (2015-11-16)
- Added Chefspec matchers

## v2.0.0 (2015-10-21)
- Migrated LWRP to Chef 12.5 custom resources format with backwards compatibility provided via compat_resource cookbook to 12.X family
- Added Start / enable of iptables service in the default recipe when on RHEL based systems and the management of /etc/sysconfig/iptables so the service can start
- Added removal of /etc/iptables.d/ to the disabled recipe to allow for reenabling later on
- Modified the iptables service disable in the disable recipe to only run when on RHEL based systems
- Expanded the serverspec tests and test kitchen suites to better test rules custom resource and disable recipe

## v1.1.0 (2015-10-05)
- Fixed metadata description of the default recipe
- Added Kitchen CI config
- Added Chefspec unit tests
- Updated to our standard Rubocop config and resolve all warnings
- Added Travis CI config for lint / unit testing on Ruby 2/2.1/2.2
- Updated Contributing and Testing docs
- Added a maintainers doc
- Added a Gemfile with development and testing dependencies
- Added cookbook version and Travis CI badges to the readme
- Clarified in the readme that the minimum supported Chef release is 11.0
- Added a Rakefile easier testing
- Added a chefignore file to limit files that are uploaded to the Chef server
- Update to modern notification format to resolve Foodcritic warnings
- Added source_url and issues_url to the metadata for Supermarket
- Removed pre-Ruby 1.9 hash rockets

## v1.0.0 (2015-04-29)
NOTE: This release includes breaking changes to the behavior of this cookbook. The iptables_rule definition was converted to a LWRP.  This changes the behavior of disabling iptables rules.  Previously a rule could be disabled by specifying `enable false`.  You must now specify `action :disable`.  Additionally the cookbook no longer installs the out of the box iptables rules.  These were rules made assumptions about the operating environment and should not have been installed out of the box. This makes this recipe a library cookbook that can be better wrapped to meet the needs or your particular environment.
- Definition converted to a LWRP to providing why-run support and
- The out of the box iptables rules are no longer installed.  If you need these rules you'll need to wrap the cookbook and use the LWRP to define these same rules.
- Removed all references to the roadmap and deprecation of the cookbook.  It's not going anywhere any time soon
- Use platform_family to better support Debian derivatives
- Converted file / directory modes to strings to preserve the leading 0
- Added additional RHEL derivitive distributions to the metadata
- Expanded excluded files in the gitignore and chefignore files
- Included the latest contributing documentation to match the current process

## v0.14.1 (2015-01-01)
- Fixing File.exists is deprecated for File.exist

## v0.14.0 (2014-08-31)
- [#14] Adds basic testing suite including Berksfile
- [#14] Adds basic integration/post-converge tests
- [#14] Adds default prefix and postfix rules to disalow traffic

## v0.13.2 (2014-04-09)
- [COOK-4496] Added Amazon Linux support

## v0.13.0 (2014-03-19)
- [COOK-3927] Substitute Perl version of rebuild-iptables with Ruby version

## v0.12.2 (2014-03-18)
- [COOK-4411] - Add newling to iptables.snat

## v0.12.0
- [COOK-2213] - iptables disabled recipe

## v0.11.0
- [COOK-1883] - add perl package so rebuild script works

## v0.10.0
- [COOK-641] - be able to save output on rhel-family
- [COOK-655] - use a template from other cookbooks

## v0.9.3
- Current public release.
