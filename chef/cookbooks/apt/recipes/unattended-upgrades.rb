#
# Cookbook:: apt
# Recipe:: unattended-upgrades
#
# Copyright:: 2014-2017, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# On systems where apt is not installed, the resources in this recipe are not
# executed. However, they _must_ still be present in the resource collection
# or other cookbooks which notify these resources will fail on non-apt-enabled
# systems.
#

package 'unattended-upgrades' do # ~FC009
  response_file 'unattended-upgrades.seed.erb'
  action :install
end

package 'bsd-mailx' do
  not_if { node['apt']['unattended_upgrades']['mail'].nil? }
end

template '/etc/apt/apt.conf.d/20auto-upgrades' do
  owner 'root'
  group 'root'
  mode '0644'
  source '20auto-upgrades.erb'
end

template '/etc/apt/apt.conf.d/50unattended-upgrades' do
  owner 'root'
  group 'root'
  mode '0644'
  source '50unattended-upgrades.erb'
end
