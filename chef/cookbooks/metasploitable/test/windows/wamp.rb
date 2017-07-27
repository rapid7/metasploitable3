control "wamp" do
  title "Check WAMP installation"
  desc "Check WAMP installation. The setup script available at /scripts/installs/install_wamp.bat"

  describe file('C:\\wamp\\bin\\apache\\Apache2.2.21\\conf\\httpd.conf') do
   it { should exist }
  end

  describe file('C:\\wamp\\alias\\phpmyadmin.conf') do
   it { should exist }
  end

  describe service('wampapache') do
   it { should be_installed }
   it { should be_enabled }
   it { should be_running }
  end

  describe service('wampmysqld') do
   it { should be_installed }
   it { should be_enabled }
   it { should be_running }
  end

  #TODO: Add icacls verification

  describe port('8585') do
   it { should be_listening }
  end

  describe port('3306') do
   it { should be_listening }
  end
end

