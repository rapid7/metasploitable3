control "manageengine" do
  title "ManageEngine"
  desc "Check if ManageEngine is running. Installation script is available at /scripts/installs/install_manageengine.bat"

  describe service('MEDCServerComponent-Apache') do
   it { should be_installed }
   it { should be_enabled }
   it { should be_running }
  end

  describe service('MEDC Server Component - Notification Server') do
   it { should be_installed }
   it { should be_enabled }
   it { should be_running }
  end

  describe service('DesktopCentralServer') do
   it { should be_installed }
   it { should be_enabled }
   it { should be_running }
  end

  describe port('8020') do
   it { should be_listening }
  end
end
