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

include_recipe 'iptables::_package'

%w(iptables ip6tables).each do |ipt|
  service ipt do
    action [:disable, :stop]
    delayed_action :stop
    supports status: true, start: true, stop: true, restart: true
    only_if { %w(rhel fedora amazon).include?(node['platform_family']) }
  end

  # Necessary so that if iptables::disable is used and then later
  # it is re-enabled without any rules changes, the templates will run the rebuilt script
  directory "/etc/#{ipt}.d" do
    action :delete
    recursive true
    notifies :run, "execute[#{ipt}Flush]", :immediately
  end

  ["/etc/sysconfig/#{ipt}", "/etc/sysconfig/#{ipt}.fallback"].each do |f|
    file f do
      content '# iptables rules files cleared by chef via iptables::disabled'
      only_if { %w(rhel fedora amazon).include?(node['platform_family']) }
      notifies :run, "execute[#{ipt}Flush]", :immediately
    end
  end

  # Flush and delete iptables rules
  execute "#{ipt}Flush" do
    command "#{ipt} -F"
    action :nothing
  end
end
