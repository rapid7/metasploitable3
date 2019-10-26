#
# Cookbook:: test
# Recipe:: base
#
# Copyright:: 2016-2017, Chef Software, Inc.
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

apt_update 'update'

# without this dist data won't be populated by Ohai in docker
if platform?('debian')
  package 'lsb-release' do
    action :install
    notifies :reload, 'ohai[reload_ohai]', :immediately
  end

  ohai 'reload_ohai' do
    action :nothing
  end
end

include_recipe 'apt::default'
