control "tomcat" do
  title "Check tomcat installation"
  desc "Check if tomcat is installed. Installation script available at /scripts/chocolatey_installs/tomcat.bat"

  describe file('C:\\Program Files\\Apache Software Foundation\\tomcat') do
   it { should exist }
  end

  describe command('sc query Tomcat8') do
   its('stdout') { should match('STATE              : 4  RUNNING') }
  end

  describe command('netstat -aob | findstr :8282') do
   its('stdout') { should match ("LISTENING") }
  end

end
