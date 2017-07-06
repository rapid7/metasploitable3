control "disable-firewall" do
  title "Diable firewall"
  desc "Disable firewall. Configuration script available at /scripts/configs/disable_firewall.bat"

  # There are three profiles. None of them should be in 'on' state
  describe command('netsh advfirewall show allprofiles state') do
   its('stdout') { should_not match ("ON") }
  end
end
