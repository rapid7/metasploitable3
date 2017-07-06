control "check-accounts" do
  title "Check user accounts"
  desc "This test is to make sure that all the user accounts are created"

  describe command('net user anakin_skywalker') do
    its(:exit_status) { should eq 0 }
  end

  describe command('net user artoo_detoo') do
    its(:exit_status) { should eq 0 }
  end

  describe command('net user ben_kenobi') do
    its(:exit_status) { should eq 0 }
  end

  describe command('net user boba_fett') do
    its(:exit_status) { should eq 0 }
  end

  describe command('net user c_three_pio') do
    its(:exit_status) { should eq 0 }
  end

  describe command('net user chewbacca') do
    its(:exit_status) { should eq 0 }
  end

  describe command('net user darth_vader') do
    its(:exit_status) { should eq 0 }
  end

  describe command('net user greedo') do
    its(:exit_status) { should eq 0 }
  end

  describe command('net user han_solo') do
    its(:exit_status) { should eq 0 }
  end

  describe command('net user jabba_hutt') do
    its(:exit_status) { should eq 0 }
  end

  describe command('net user jarjar_binks') do
    its(:exit_status) { should eq 0 }
  end

  describe command('net user kylo_ren') do
    its(:exit_status) { should eq 0 }
  end

  describe command('net user lando_calrissian') do
    its(:exit_status) { should eq 0 }
  end

  describe command('net user leia_organa') do
    its(:exit_status) { should eq 0 }
  end

  describe command('net user luke_skywalker') do
    its(:exit_status) { should eq 0 }
  end

  describe command('net user sshd') do
    its(:exit_status) { should eq 0 }
  end

  describe command('net user sshd_server') do
    its(:exit_status) { should eq 0 }
  end

  describe command('net user vagrant') do
    its(:exit_status) { should eq 0 }
  end
end

control "check-localgroups" do
  title "Check LocalGroups"
  desc "Check if the users are added to their repective localgroups"

  describe command('net localgroup "Backup Operators"') do
   its('stdout') { should match ("leia_organa") }
  end

  describe command('net localgroup "Certificate Service DCOM Access"') do
   its('stdout') { should match ("luke_skywalker") }
  end

  describe command('net localgroup "Cryptographic Operators"') do
   its('stdout') { should match ("han_solo") }
  end

  describe command('net localgroup "Distributed COM Users"') do
   its('stdout') { should match ("artoo_detoo") }
  end

  describe command('net localgroup "Event Log Readers"') do
   its('stdout') { should match ("c_three_pio") }
  end

  describe command('net localgroup "Guests"') do
   its('stdout') { should match ("ben_kenobi") }
  end

  describe command('net localgroup "IIS_IUSRS"') do
   its('stdout') { should match ("darth_vader") }
  end

  describe command('net localgroup "Network Configuration Operators"') do
   its('stdout') { should match ("anakin_skywalker") }
  end

  describe command('net localgroup "Performance Log Users"') do
   its('stdout') { should match ("jarjar_binks") }
  end

  describe command('net localgroup "Performance Monitor Users"') do
   its('stdout') { should match ("lando_calrissian") }
  end

  describe command('net localgroup "Power Users"') do
   its('stdout') { should match ("boba_fett") }
  end

  describe command('net localgroup "Print Operators"') do
   its('stdout') { should match ("jabba_hutt") }
  end

  describe command('net localgroup "Remote Desktop Users"') do
   its('stdout') { should match ("greedo") }
  end

  describe command('net localgroup "Replicator"') do
   its('stdout') { should match ("chewbacca") }
  end
end

control "reg-user-add" do
  title "Check user registry entries"
  desc "Check if the registry was updated with the new users and their groups. Configuration script available at /scripts/configs/create_users.bat"

  describe command('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList"') do
   its('stdout') { should match ("leia_organa    REG_DWORD    0x0\r\n    luke_skywalker    REG_DWORD    0x0\r\n    han_solo    REG_DWORD    0x0\r\n    artoo_detoo    REG_DWORD    0x0\r\n    c_three_pio    REG_DWORD    0x0\r\n    ben_kenobi    REG_DWORD    0x0\r\n    darth_vader    REG_DWORD    0x0\r\n    anakin_skywalker    REG_DWORD    0x0\r\n    jarjar_binks    REG_DWORD    0x0\r\n    lando_calrissian    REG_DWORD    0x0\r\n    boba_fett    REG_DWORD    0x0\r\n    jabba_hutt    REG_DWORD    0x0\r\n    greedo    REG_DWORD    0x0\r\n    chewbacca    REG_DWORD    0x0\r\n    kylo_ren    REG_DWORD    0x0") }
  end
end
