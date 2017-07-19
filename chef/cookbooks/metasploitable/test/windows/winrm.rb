control "winrm" do
  title "WinRM"
  desc "Checks if the port 5985 is listening"

  describe port('5985') do
   it { should be_listening }
  end

end
