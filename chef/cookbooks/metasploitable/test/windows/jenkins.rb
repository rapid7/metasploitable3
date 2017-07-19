control "jenkins" do
  title "Check jenkins"
  desc "Check if jenkins is installed correctly. The setup script is available at /scripts/installs/setup_jenkins.bat"

  describe file("C:\\Program Files\\jenkins") do
   it { should exist }
  end

  describe file("C:\\Program Files\\jenkins\\jenkins.war") do
   it { should exist }
  end

  describe file("C:\\Program Files\\jenkins\\jenkins.exe") do
   it { should exist }
  end

  describe service('jenkins') do
   it { should be_installed }
   it { should be_enabled }
   it { should be_running }
  end

  describe port('8484') do
   it { should be_listening }
  end
end
