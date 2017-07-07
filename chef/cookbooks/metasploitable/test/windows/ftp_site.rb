control "setup-ftp-site" do
  title "Setup FTP Site"
  desc "Check if the FTP site is correctly configured"

  describe file('C:\\Windows\\System32\\inetsrv\\config\\applicationHost.config') do
   it { should exist }
  end

  describe command('netstat -aob | findstr :21') do
   its('stdout') { should match ("LISTENING") }
  end

end
