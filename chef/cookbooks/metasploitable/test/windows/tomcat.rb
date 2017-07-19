control "tomcat" do
  title "Check tomcat installation"
  desc "Check if tomcat is installed. Installation script available at /scripts/chocolatey_installs/tomcat.bat"

  describe file('C:\\Program Files\\Apache Software Foundation\\tomcat') do
   it { should exist }
  end

  describe service('Tomcat8') do
   it { should be_installed }
   it { should be_enabled }
   it { should be_running }
  end

  describe port('8282') do
   it { should be_listening }
  end

end
