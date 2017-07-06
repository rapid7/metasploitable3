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

  describe command("sc query jenkins") do
   its('stdout') { should match ("STATE              : 4  RUNNING") }
  end

  describe command("netstat -aob | findstr :8484") do
   its('stdout') { should match ("LISTENING") }
  end
end
