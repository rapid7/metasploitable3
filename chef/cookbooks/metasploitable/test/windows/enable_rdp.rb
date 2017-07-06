control "enable-rdp" do
  title "Enable RDP"
  desc "Enables RDP by modifying Registry and adding a Firewall rule. Configuration script available at /scripts/configs/enable-rdp.bat"

  describe command('netsh advfirewall firewall show rule name="Open Port 3389"') do
   its('stdout') { should match ("Enabled:                              Yes") }
  end

  describe command('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections') do
   its('stdout') { should match ("fDenyTSConnections    REG_DWORD    0x0") }
  end

  # As port('3389') doesnt work on windows, we use netstat command to know if the port is listening
  describe command('netstat -aob | findstr :3389') do
   its('stdout') { should match ("LISTENING") }
  end
end
