#
# Cookbook:: apt
# Recipe:: default
#
# Copyright:: 2008-2017, Chef Software, Inc.
# Copyright:: 2009-2017, Bryan McLellan <btm@loftninjas.org>
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

file '/var/lib/apt/periodic/update-success-stamp' do
  owner 'root'
  group 'root'
  action :nothing
end

# If compile_time_update run apt-get update at compile time
if node['apt']['compile_time_update'] && apt_installed?
  apt_update('compile time') do
    frequency node['apt']['periodic_update_min_delay']
    ignore_failure true
  end.run_action(:periodic)
end

apt_update 'periodic' do
  frequency node['apt']['periodic_update_min_delay']
end

# For other recipes to call to force an update
execute 'apt-get update' do
  command 'apt-get update'
  ignore_failure true
  action :nothing
  notifies :touch, 'file[/var/lib/apt/periodic/update-success-stamp]', :immediately
  only_if { apt_installed? }
end

# Automatically remove packages that are no longer needed for dependencies
execute 'apt-get autoremove' do
  command 'apt-get -y autoremove'
  environment(
    'DEBIAN_FRONTEND' => 'noninteractive'
  )
  action :nothing
  only_if { apt_installed? }
end

# Automatically remove .deb files for packages no longer on your system
execute 'apt-get autoclean' do
  command 'apt-get -y autoclean'
  action :nothing
  only_if { apt_installed? }
end

%w(/var/cache/local /var/cache/local/preseeding).each do |dirname|
  directory dirname do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
    only_if { apt_installed? }
  end
end

template '/etc/apt/apt.conf.d/10dpkg-options' do
  owner 'root'
  group 'root'
  mode '0644'
  source '10dpkg-options.erb'
  only_if { apt_installed? }
end

template '/etc/apt/apt.conf.d/10recommends' do
  owner 'root'
  group 'root'
  mode '0644'
  source '10recommends.erb'
  only_if { apt_installed? }
end

package %w(apt-transport-https gnupg dirmngr) do
  only_if { apt_installed? }
end
