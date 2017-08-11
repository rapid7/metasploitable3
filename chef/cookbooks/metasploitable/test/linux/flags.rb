# Inspec Tests for Linux Flags

describe file('/opt/knock_knock/five_of_diamonds') do
  it { should be_file }
  it { should be_executable }
  it { should be_owned_by 'root' }
  its('mode') { should cmp '0700' }
  its('md5sum') { should eq 'b4542ea3449e164df583f39319e66655' }
end

describe file('/opt/init/five_of_diamonds_srv.conf') do
  it { should be_file }
  it { should be_executable }
  it { should be_owned_by 'root' }
  its('mode') { should cmp '777' }
  its('md5sum') { should eq 'dccf7f60af61f3a25afcd27040d6c486' }
end

describe port('8989') do
  it { should be_listening }
end

describe service('five_of_diamonds_srv') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/home/artoo_detoo/music/10_of_clubs.wav') do
  it { should be_file }
  it { should be_owned_by 'artoo_detoo' }
  its('mode') { should cmp '400' }
  its('md5sum') { should eq '5b97f084aa90c4b9504725519cf5204e' }
end

describe file('/etc/joker.png') do
  it { should be_file }
  it { should be_owned_by 'root' }
  its('mode') { should cmp '644' }
  its('md5sum') { should eq '1fe82fcb96be25ef155f741811d58dac' }
end

describe command('docker cp 7_of_diamonds:/home/7_of_diamonds.zip .') do
  its('exit_status') { should eq 0 }
end

describe file('/home/leia_organa/2_of_spades.pcapng') do
  it { should be_file }
  it { should be_owned_by 'leia_organa' }
  its('mode') { should cmp '600' }
  its('md5sum') { should eq 'bbbd4b738b5521cb3df8a78b1f3214d7' }
end

# 8 of Hearts tests
describe command('mysql -h 127.0.0.1 --user="root" --password="sploitme" --database="super_secret_db" --execute="USE super_secret_db; SELECT \'8_of_hearts\' FROM flags;"') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match /8_of_hearts/ } # TODO: This test just makes sure the SQL output contains '8_of_hearts'. It doesnt actually verify the correct flag image is present
end

# King of Spades tests
describe file('/opt/unrealircd/Unreal3.2/ircd.motd') do
  it { should be_file }
  its('md5sum') { should eq '0d7cf1d19f9bc0b2ff791279a97bf5ce' }
end
