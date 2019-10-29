#
# Cookbook:: iptables
# Recipe:: _package
#
# Copyright:: 2008-2016, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# amazon linux, any fedora, and amazon linux 2
if (platform_family?('rhel') && node['platform_version'].to_i == 7) ||
   (platform_family?('amazon') && node['platform_version'].to_i < 2013) ||
   platform_family?('fedora')
  package 'iptables-services'
else
  package 'iptables'
  if platform_family?('debian')
    # Since Ubuntu 10.04LTS and Debian6, this package takes over the automatic loading of the saved iptables rules
    package 'iptables-persistent'
  end
end
