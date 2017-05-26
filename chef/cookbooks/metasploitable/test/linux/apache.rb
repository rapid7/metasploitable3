# Inspec Tests for the Linux version
# All of these tests must pass before release.

# Tests for Apache Continuum
describe service'continuum' do
  it { should be_running }
  it { should be_enabled }
end

# Tests for Apache webserver
describe service('apache2') do
  it { should be_running }
  it { should be_enabled }
end

describe port('80') do
  it { should be_listening }
end

# Check that the required modules are enabled.
# TODO: Is there a better way than checking symlinks?
cgi_mods = ['cgid.conf', 'cgid.load']
dav_mods = [ 'auth_digest.load', 'dav_fs.conf', 'dav_fs.load', 'dav.load', 'dav_lock.load' ]
cgi_mods + dav_mods.each do |filename|
  describe file("/etc/apache2/mods-enabled/#{filename}") do
    it { should be_symlink }
  end
end

describe command('curl http://localhost/cgi-bin/hello_world.sh') do
  its('stdout') { should match /Hello World!/ }
end
