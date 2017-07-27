control "psexec" do
  title "PxExec"
  desc "Checks if the ports 139 - NetBIOS and 445 - SMB are listening"

  describe port('139') do
   it { should be_listening }
  end

  describe port('445') do
   it { should be_listening }
  end
end

