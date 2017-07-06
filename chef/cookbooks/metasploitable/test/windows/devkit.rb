control "devkit" do
  title "Rails Server - DevKit"
  desc "Check if the rails server has installed along with devkit. Check the installation script at /scripts/installs/install_devkit.bat"

  describe file('C:\\Program Files\\Rails_Server') do
   it { should exist }
  end

  describe file('C:\\Program Files\\Rails_Server\\devkit') do
   it { should exist }
  end

  describe command('netstat -aob | findstr :3000') do
   its('stdout') { should match ("LISTENING") }
  end
end
