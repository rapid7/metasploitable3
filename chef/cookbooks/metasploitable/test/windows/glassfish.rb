control "glassfish" do
  title "Check GlassFish"
  desc "Check if the GlassFish service is correctly installed. Installation script available at /scripts/installs/setup_g"

  describe file("C:\\glassfish") do
   it { should exist }
  end

  describe file("C:\\glassfish\\glassfish4\\glassfish\\domains\\domain1\\config\\admin-keyfile") do
   it { should exist }
  end

  describe file("C:\\glassfish\\glassfish4\\glassfish\\domains\\domain1\\config\\domain.xml") do
   it { should exist }
  end

  describe service('domain1') do
   it { should be_installed }
   it { should be_enabled }
   it { should be_running }
  end  

#  describe command('icacls "C:\glassfish"') do
#   its('stdout') { should match "NT AUTHORITY\LOCAL SERVICE:(OI)(CI)(F)" }
#  end

  describe port('4848') do
   it { should be_listening }
  end

  describe port('8080') do
   it { should be_listening }
  end

  describe port('8181') do
   it { should be_listening }
  end

end
