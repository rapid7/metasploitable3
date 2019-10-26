#
# Cookbook:: test
# Recipe:: resources
#
# Copyright:: 2012-2017, Chef Software, Inc.
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
describe 'apt::resources' do
  it 'creates the JuJu sources.list' do
    skip('not on ubuntu') unless os.name == 'ubuntu'
    expect(file('/etc/apt/sources.list.d/juju.list')).to exist
  end

  it 'creates the NodeJS sources.list' do
    skip('not on ubuntu') unless os.name == 'ubuntu'
    expect(file('/etc/apt/sources.list.d/nodejs.list')).to exist
  end

  it 'creates the HAProxy sources.list' do
    skip('not on ubuntu') unless os.name == 'ubuntu'
    expect(file('/etc/apt/sources.list.d/haproxy.list')).to exist
  end

  it 'creates a repo with a url that is already quoted' do
    skip('not on ubuntu') unless os.name == 'ubuntu'
    src = 'deb\s+\"http://ppa.launchpad.net/juju/stable/ubuntu\" trusty main'
    expect(file('/etc/apt/sources.list.d/juju.list').content).to match(/#{src}/)
  end

  it 'adds the JuJu package signing key' do
    skip('not on ubuntu') unless os.name == 'ubuntu'
    expect(command('apt-key list').stdout).to include('Launchpad Ensemble PPA')
  end

  it 'creates the correct pinning preferences for chef' do
    pinning_prefs = 'Package: chef\nPin: version 12.7.2-1'
    expect(file('/etc/apt/preferences.d/chef.pref').content).to match(/#{pinning_prefs}/)
  end

  it 'correctly handles a ppa: repository' do
    skip('not on ubuntu') unless os.name == 'ubuntu'
    gimp = 'http://ppa.launchpad.net/otto-kesselgulasch/gimp/ubuntu'
    expect(file('/etc/apt/sources.list.d/gimp.list').content).to match(/#{gimp}/)
  end

  it 'renames an old preferences file' do
    expect(file('/etc/apt/preferences.d/wget')).to_not exist
    expect(file('/etc/apt/preferences.d/wget.pref')).to exist
  end

  it 'renames an invalid preferences file' do
    expect(file('/etc/apt/preferences.d/*.pref')).to_not exist
    expect(file('/etc/apt/preferences.d/wildcard.pref')).to exist
  end

  it 'removes a preferences file' do
    expect(file('/etc/apt/preferences.d/camel.pref')).to_not exist
  end

  it 'creates a repo with an architecture' do
    cloudera = 'deb\s+\[arch=amd64\] "http:\/\/archive.cloudera.com\/cdh4\/ubuntu\/precise\/amd64\/cdh" precise-cdh4 contrib'
    expect(file('/etc/apt/sources.list.d/cloudera.list').content).to match(/#{cloudera}/)
  end

  it 'creates the correct pinning preferences with a glob' do
    pinning_prefs = 'Package: \\*\nPin: origin packages.dotdeb.org'
    expect(file('/etc/apt/preferences.d/dotdeb.pref').content).to match(/#{pinning_prefs}/)
  end
end
