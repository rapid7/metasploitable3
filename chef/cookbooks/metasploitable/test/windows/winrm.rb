control "winrm" do
  title "WinRM"
  desc "Checks if the port 5985 is listening"

  describe command('netstat -aob | findstr :5985') do
   its('stdout') { should match ("LISTENING") }
  end

end
