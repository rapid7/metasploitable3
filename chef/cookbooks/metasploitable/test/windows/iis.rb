control "iis" do
  title "IIS HTTP"
  desc "Checks if the IIS server has started and listening on port 80. Setup script available at /scripts/installs/setup_iis.bat"

  describe command('netstat -aob | findstr :3389') do
   its('stdout') { should match ("LISTENING") }
  end
end
