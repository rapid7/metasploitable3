control "psexec" do
  title "PxExec"
  desc "Checks if the ports 139 - NetBIOS and 445 - SMB are listening"

  describe command('netstat -aob | findstr :139') do
   its('stdout') { should match ("LISTENING") }
  end

  describe command('netstat -aob | findstr :445') do
   its('stdout') { should match ("LISTENING") }
  end

end

