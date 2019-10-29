#
# Author:: Julien 'Lta' BALLET <contact@lta.io>
# Cookbook:: iptables
# Resource:: rule6
#
# Copyright:: 2018, Chef Software, Inc.
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
property :filemode, [String, Integer], default: '0644'

action :enable do
  iptables_rule new_resource.name do
    ipv6 true
    source new_resource.source
    cookbook new_resource.cookbook
    variables new_resource.variables
    lines new_resource.lines
    table new_resource.table
    sensitive new_resource.sensitive
    filemode new_resource.filemode
    action :enable
  end
end

action :disable do
  iptables_rule new_resource.name do
    ipv6 true
    source new_resource.source
    cookbook new_resource.cookbook
    variables new_resource.variables
    lines new_resource.lines
    table new_resource.table
    sensitive new_resource.sensitive
    filemode new_resource.filemode
    action :disable
  end
end
