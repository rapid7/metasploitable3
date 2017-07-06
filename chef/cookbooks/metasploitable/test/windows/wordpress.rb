control "wordpress" do
  title "Check WordPress Installation"
  desc "Checks the wordpress installation. Setup script available in /scripts/installs/install_wordpress.bat"

  describe file('C:\\Program Files\\wordpress') do
   it { should exist }
  end

  describe file('C:\\Program Files\\wordpress\\update_ip.ps1') do
   it { should exist }
  end

  describe file('C:\\wamp\\www\\wordpress') do
   it { should exist }
  end
end
