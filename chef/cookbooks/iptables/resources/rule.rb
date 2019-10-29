#
# Author:: Tim Smith <tsmith84@gmail.com>
# Cookbook:: iptables
# Resource:: rule
#
# Copyright:: 2015-2018, Tim Smith
# Copyright:: 2017-2018, Chef Software, Inc.
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

property :source, String
property :cookbook, String
property :variables, Hash, default: {}
property :lines, String
property :table, Symbol
property :ipv6, [TrueClass, FalseClass], default: false
property :filemode, [String, Integer], default: '0644'

action :enable do
  ipt = new_resource.ipv6 ? 'ip6tables' : 'iptables'

  # ensure we have execute[rebuild-iptables] in the outer run_context
  with_run_context :root do
    find_resource(:execute, "rebuild-#{ipt}") do
      command "/usr/sbin/rebuild-#{ipt}"
      action :nothing
    end
  end

  if new_resource.lines.nil?
    template "/etc/#{ipt}.d/#{new_resource.name}" do
      source new_resource.source ? new_resource.source : "#{new_resource.name}.erb"
      mode new_resource.filemode
      cookbook new_resource.cookbook if new_resource.cookbook
      variables new_resource.variables
      backup false
      sensitive new_resource.sensitive
      notifies :run, "execute[rebuild-#{ipt}]", :delayed
    end
  else
    new_resource.lines = "*#{new_resource.table}\n" + new_resource.lines if new_resource.table
    file "/etc/#{ipt}.d/#{new_resource.name}" do
      content new_resource.lines
      mode new_resource.filemode
      backup false
      sensitive new_resource.sensitive
      notifies :run, "execute[rebuild-#{ipt}]", :delayed
    end
  end
end

action :disable do
  ipt = new_resource.ipv6 ? 'ip6tables' : 'iptables'

  # ensure we have execute[rebuild-iptables] in the outer run_context
  with_run_context :root do
    find_resource(:execute, "rebuild-#{ipt}") do
      command "/usr/sbin/rebuild-#{ipt}"
      action :nothing
    end
  end

  file "/etc/#{ipt}.d/#{new_resource.name}" do
    action :delete
    backup false
    sensitive new_resource.sensitive
    notifies :run, "execute[rebuild-#{ipt}]", :delayed
  end
end
