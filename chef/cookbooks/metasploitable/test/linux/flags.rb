require '../helpers/chat_test.rb'

# Inspec Tests for Linux Flags

# 10 of clubs tests
describe file('/home/artoo_detoo/music/10_of_clubs.wav') do
  it { should be_file }
  it { should be_owned_by 'artoo_detoo' }
  its('mode') { should cmp '400' }
  its('md5sum') { should eq '5b97f084aa90c4b9504725519cf5204e' }
end

describe command('docker cp 7_of_diamonds:/home/7_of_diamonds.zip .') do
  its('exit_status') { should eq 0 }
end

# King of Spades tests
describe file('/opt/unrealircd/Unreal3.2/ircd.motd') do
  it { should be_file }
  its('md5sum') { should eq 'be373836982164f7b479f8c12cc03e90' }
end

describe processes('/opt/unrealircd/Unreal3.2/src/ircd') do
  its('users') { should eq ['boba_fett'] }
end

# 5 of Hearts tests
describe command('curl http://localhost/drupal/?q=node/2') do
  its('stdout') { should match /5_of_hearts\.png/ } # Make sure it has the icon
end

# Ace of Clubs tests
# NOTE: The chatbot can get a little laggy if there is a lot of data in the log.
# This can cause this test to fail incorrectly.
# To remedy, clear the /var/www/log.html file on metasploitable and restart the chatbot service.
describe 'ace_of_clubs' do
  let(:host_ip) { command("ip addr | grep 'state UP' -A2 | grep 'eth0' | tail -n1 | awk '{print $2}' | cut -f1  -d'/'").stdout.strip }

  it 'should print out the correct base64 flag' do
    ct = ChatTest.new(host_ip)
    expect(ct.check_chat_bot).to eq true #TODO: Make this output more meaningful. e.g. output what was returned and what was expected.
  end
end

# Tests for "Hard mode" flags
if ENV['MS3_LINUX_HARD']

  # Red Joker tests
  describe file('/etc/joker.png') do
    it { should be_file }
    it { should be_owned_by 'root' }
    its('mode') { should cmp '644' }
    its('md5sum') { should eq '1fe82fcb96be25ef155f741811d58dac' }
  end

  # 2 of Spades tests
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

  # 5 of Diamonds tests
  describe file('/opt/knock_knock/five_of_diamonds') do
    it { should be_file }
    it { should be_executable }
    it { should be_owned_by 'root' }
    its('mode') { should cmp '0700' }
    its('md5sum') { should eq 'b4542ea3449e164df583f39319e66655' }
  end

  describe file('/etc/init/five_of_diamonds_srv.conf') do
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

else
  # Tests for "Easy mode" flags

  # 10 of Spades tests
  describe file('/opt/readme_app/public/images/10_of_spades.png') do
    it { should be_file }
    its('mode') { should cmp '644'}
  end

  # 8 of Clubs tests
  describe command('find /home/anakin_skywalker -name "*clubs*"') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /8_of_clubs\.png/}
  end

  # 3 of Hearts tests
  describe file('/lost+found/3_of_hearts.png') do
    it { should be_file }
    its('mode')  { should cmp '600' }
    its('owner') { should eq 'root' }
    its('group') { should eq 'root' }
  end

  # 9 of Diamonds tests
  describe file('/home/kylo_ren/.secret_files/my_recordings_do_not_open.iso') do
    it { should be_file }
    its('mode')  { should cmp '600' }
    its('owner') { should eq 'kylo_ren' }
    its('group') { should eq 'users' }
  end
end