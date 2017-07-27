control "snmp" do
  title "Setup SNMP"
  desc "Check if SNMP has been set up correctly. Setup script available at /scripts/installs/setup_snmp.bat"

  describe registry_key('HKLM\SYSTEM\ControlSet001\services\SNMP\Parameters') do
   its('EnableAuthenticationTraps') { should eq 0 }
  end

  describe registry_key('HKLM\SYSTEM\ControlSet001\services\SNMP\Parameters\ValidCommunities') do
   its('public') { should eq 4 }
  end

  describe port('161') do
   it { should be_listening }
  end
end
