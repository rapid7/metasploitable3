#
# Cookbook:: test
# Recipe:: cacher-ng-client_test.rb
#
# Copyright:: 2013-2017, Chef Software, Inc.
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

describe 'test::cacher' do
  it 'runs the cacher service' do
    expect(service('apt-cacher-ng')).to be_running
  end

  it 'creates the cacher_dir' do
    expect(file('/var/cache/apt-cacher-ng')).to be_directory
    expect(file('/var/cache/apt-cacher-ng')).to be_owned_by('apt-cacher-ng')
  end

  it 'runs the cacher service' do
    expect(service('apt-cacher-ng')).to be_running
  end

  it 'creates 01proxy' do
    expect(file('/etc/apt/apt.conf.d/01proxy').content).to match(%r{Acquire::http::Proxy "http://.*:9876";})
  end

  it 'installed colordiff' do
    expect(package('colordiff')).to be_installed
  end
end
