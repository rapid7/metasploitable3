control "webdav" do
  title "WebDAV"
  desc "Check if WebDAV is correctly installed. Installation script available at /scripts/installs/setup_webdav.bat"

  describe file('C:\\wamp\\www\\uploads') do
   it { should exist }
  end

  describe file('C:\\wamp\\alias\\httpd-dav.conf') do
   it { should exist }
  end

  describe service('wampapache') do
   it { should be_installed }
   it { should be_enabled }
   it { should be_running }
  end

  describe port('8585') do
   it { should be_listening }
  end
end
