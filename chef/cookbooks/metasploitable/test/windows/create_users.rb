control "check-accounts" do
  title "Check user accounts"
  desc "This test is to make sure that all the user accounts are created and are assigned to correct localgroups"

  describe user('anakin_skywalker') do
    it { should exist }
    its('groups') { should eq ["Network Configuration Operators", "Users"] }
  end

  describe user('artoo_detoo') do
    it { should exist }
    its('groups') { should eq ["Distributed COM Users", "Users"] }
  end

  describe user('ben_kenobi') do
    it { should exist }
    its('groups') { should eq ["Guests", "Users"] }
  end

  describe user('boba_fett') do
    it { should exist }
    its('groups') { should eq ["Power Users", "Users"] }
  end

  describe user('c_three_pio') do
    it { should exist }
    its('groups') { should eq ["Event Log Readers", "Users"] }
  end

  describe user('chewbacca') do
    it { should exist }
    its('groups') { should eq ["Replicator", "Users"] }
  end

  describe user('darth_vader') do
    it { should exist }
    its('groups') { should eq ["IIS_IUSRS", "Users"] }
  end

  describe user('greedo') do
    it { should exist }
    its('groups') { should eq ["Remote Desktop Users", "Users"] }
  end

  describe user('han_solo') do
    it { should exist }
    its('groups') { should eq ["Cryptographic Operators", "Users"] }
  end

  describe user('jabba_hutt') do
    it { should exist }
    its('groups') { should eq ["Print Operators", "Users"] }
  end

  describe user('jarjar_binks') do
    it { should exist }
    its('groups') { should eq ["Performance Log Users", "Users"] }
  end

  describe user('kylo_ren') do
    it { should exist }
    its('groups') { should eq ["Users"] }
  end

  describe user('lando_calrissian') do
    it { should exist }
    its('groups') { should eq ["Performance Monitor Users", "Users"] }
  end

  describe user('leia_organa') do
    it { should exist }
    its('groups') { should eq ["Backup Operators", "Users"] }
  end

  describe user('luke_skywalker') do
    it { should exist }
    its('groups') { should eq ["Certificate Service DCOM Access", "Users"] }
  end

  describe user('sshd') do
    it { should exist }
    its('groups') { should eq ["Users"] }
  end

  describe user('sshd_server') do
    it { should exist }
    its('groups') { should eq ["Administrators", "Users"] }
  end

  describe user('vagrant') do
    it { should exist }
    its('groups') { should eq ["Administrators", "Users"] }
  end
end

control "reg-user-add" do
  title "Check user registry entries"
  desc "Check if the registry was updated with the new users and their groups. Configuration script available at /scripts/configs/create_users.bat"

  describe registry_key('HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList') do
    its('anakin_skywalker') { should eq 0 }
    its('artoo_detoo') { should eq 0 }
    its('ben_kenobi') { should eq 0 }
    its('boba_fett') { should eq 0 }
    its('c_three_pio') { should eq 0 }
    its('chewbacca') { should eq 0 }
    its('darth_vader') { should eq 0 }
    its('greedo') { should eq 0 }
    its('han_solo') { should eq 0 }
    its('jabba_hutt') { should eq 0 }
    its('jarjar_binks') { should eq 0 }
    its('kylo_ren') { should eq 0 }
    its('lando_calrissian') { should eq 0 }
    its('leia_organa') { should eq 0 }
    its('luke_skywalker') { should eq 0 }
  end
end
