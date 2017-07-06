control "manageengine" do
  title "ManageEngine"
  desc "Check if ManageEngine is running. Installation script is available at /scripts/installs/install_manageengine.bat"

  describe command('sc query MEDCServerComponent-Apache') do
   its('stdout') { should match ("STATE              : 4  RUNNING") }
  end

  describe command('sc query "MEDC Server Component - Notification Server"') do
   its('stdout') { should match ("STATE              : 4  RUNNING") }
  end

  describe command('sc query DesktopCentralServer') do
   its('stdout') { should match ("STATE              : 4  RUNNING") }
  end

  describe command('netstat -aob | findstr :8020') do
   its('stdout') { should match "LISTENING" }
  end
end
