control "webdav" do
  title "WebDAV"
  desc "Check if WebDAV is correctly installed. Installation script available at /scripts/installs/setup_webdav.bat"

  describe file('C:\\wamp\\www\\uploads') do
   it { should exist }
  end

  describe file('C:\\wamp\\alias\\httpd-dav.conf') do
   it { should exist }
  end

  describe command('sc query wampapache') do
   its('stdout') { should match "STATE              : 4  RUNNING" }
  end

  describe command('netstat -aob | findstr :8585') do
   its('stdout') { should match "LISTENING" }
  end
end
