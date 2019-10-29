#
# Cookbook:: iptables
# Recipe:: default
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

system_ruby = node['iptables']['system_ruby']

case node['platform_family']
when 'rhel', 'fedora', 'amazon'
  node.default['iptables']['persisted_rules_iptables'] =
    '/etc/sysconfig/iptables'
  node.default['iptables']['persisted_rules_ip6tables'] =
    '/etc/sysconfig/ip6tables'
when 'debian'
  node.default['iptables']['persisted_rules_iptables'] =
    '/etc/iptables/rules.v4'
  node.default['iptables']['persisted_rules_ip6tables'] =
    '/etc/iptables/rules.v6'
end

include_recipe 'iptables::_package'

%w(iptables ip6tables).each do |ipt|
  execute "rebuild-#{ipt}" do
    command "/usr/sbin/rebuild-#{ipt}"
    action :nothing
  end

  directory "/etc/#{ipt}.d" do
    action :create
  end

  template "/usr/sbin/rebuild-#{ipt}" do
    source 'rebuild-iptables.erb'
    mode '0755'
    variables(
      ipt: ipt,
      hashbang: ::File.exist?(system_ruby) ? system_ruby : '/opt/chef/embedded/bin/ruby',
      persisted_file: node['iptables']["persisted_rules_#{ipt}"]
    )
  end

  if platform_family?('debian')
    # debian based systems load iptables during the interface activation
    template "/etc/network/if-pre-up.d/#{ipt}_load" do
      source 'iptables_load.erb'
      mode '0755'
      variables iptables_save_file: "/etc/#{ipt}/general",
                iptables_restore_binary: "/sbin/#{ipt}-restore"
    end
  elsif platform_family?('rhel', 'fedora', 'amazon')
    # iptables service exists only on RHEL based systems
    file "/etc/sysconfig/#{ipt}" do
      content '# Chef managed placeholder to allow iptables service to start'
      action :create_if_missing
    end

    template "/etc/sysconfig/#{ipt}-config" do
      source 'iptables-config.erb'
      mode '600'
      variables config: node['iptables']["#{ipt}_sysconfig"]
    end

    service ipt do
      action [:enable, :start]
      supports status: true, start: true, stop: true, restart: true
    end
  end
end
