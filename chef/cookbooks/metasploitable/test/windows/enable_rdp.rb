control "enable-rdp" do
  title "Enable RDP"
  desc "Enables RDP by modifying Registry and adding a Firewall rule. Configuration script available at /scripts/configs/enable-rdp.bat"

  describe command('netsh advfirewall firewall show rule name="Open Port 3389"') do
   its('stdout') { should match ("Enabled:                              Yes") }
  end

  describe registry_key('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server') do
   its('fDenyTSConnections') { should eq 0 }
  end  

  describe port('3389') do
   it { should be_listening }
  end
end
