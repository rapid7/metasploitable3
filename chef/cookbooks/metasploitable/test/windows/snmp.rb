control "snmp" do
  title "Setup SNMP"
  desc "Check if SNMP has been set up correctly. Setup script available at /scripts/installs/setup_snmp.bat"

  describe command('reg query "HKLM\SYSTEM\ControlSet001\services\SNMP\Parameters" /v EnableAuthenticationTraps') do
   its('stdout') { should match ("REG_DWORD    0x0") }
  end

  describe command('reg query "HKLM\SYSTEM\ControlSet001\services\SNMP\Parameters\ValidCommunities" /v public') do
   its('stdout') { should match ("REG_DWORD    0x4") }
  end

  describe command('netstat -aob | findstr :161') do
   its('stdout') { should match "LISTENING" }
  end
end
