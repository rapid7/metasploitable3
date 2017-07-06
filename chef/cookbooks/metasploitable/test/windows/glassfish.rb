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

  describe command('sc query domain1') do
   its('stdout') { should match ('STATE              : 4  RUNNING') }
  end

#  describe command('icacls "C:\glassfish"') do
#   its('stdout') { should match "NT AUTHORITY\LOCAL SERVICE:(OI)(CI)(F)" }
#  end
end
