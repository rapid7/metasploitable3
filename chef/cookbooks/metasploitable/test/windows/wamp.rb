control "wamp" do
  title "Check WAMP installation"
  desc "Check WAMP installation. The setup script available at /scripts/installs/install_wamp.bat"

  describe file('C:\\wamp\\bin\\apache\\Apache2.2.21\\conf\\httpd.conf') do
   it { should exist }
  end

  describe file('C:\\wamp\\alias\\phpmyadmin.conf') do
   it { should exist }
  end

  describe command('sc query wampapache') do
   its('stdout') { should match ("STATE              : 4  RUNNING") }
  end

  describe command('sc query wampmysqld') do
   its('stdout') { should match ("STATE              : 4  RUNNING") }
  end

  #TODO: Add icacls verification

  describe command('netstat -aob | findstr :8585') do
   its('stdout') { should match ("LISTENING") }
  end

  describe command('netstat -aob | findstr :3306') do
   its('stdout') { should match ("LISTENING") }
  end
end

