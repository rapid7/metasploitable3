#
# Cookbook:: iptables
# Attribute:: default
#
# Copyright:: 2016, Chef Software, Inc.
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

default['iptables']['iptables_sysconfig'] = {
  'IPTABLES_MODULES' => '',
  'IPTABLES_MODULES_UNLOAD' => 'yes',
  'IPTABLES_SAVE_ON_STOP' => 'no',
  'IPTABLES_SAVE_ON_RESTART' => 'no',
  'IPTABLES_SAVE_COUNTER' => 'no',
  'IPTABLES_STATUS_NUMERIC' => 'yes',
  'IPTABLES_STATUS_VERBOSE' => 'no',
  'IPTABLES_STATUS_LINENUMBERS' => 'yes',
}
default['iptables']['ip6tables_sysconfig'] = {
  'IP6TABLES_MODULES' => '',
  'IP6TABLES_MODULES_UNLOAD' => 'yes',
  'IP6TABLES_SAVE_ON_STOP' => 'no',
  'IP6TABLES_SAVE_ON_RESTART' => 'no',
  'IP6TABLES_SAVE_COUNTER' => 'no',
  'IP6TABLES_STATUS_NUMERIC' => 'yes',
  'IP6TABLES_STATUS_VERBOSE' => 'no',
  'IP6TABLES_STATUS_LINENUMBERS' => 'yes',
}

default['iptables']['system_ruby'] = '/usr/bin/ruby'
