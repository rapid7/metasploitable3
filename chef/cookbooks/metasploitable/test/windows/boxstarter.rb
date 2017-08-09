control "boxstarter" do
  title "Check BoxStarter"
  desc "Check if BoxStarter is installed successfully"

  describe file('C:\\Users\\vagrant\\AppData\\Roaming\\Boxstarter') do
   it { should exist }              
  end

  describe file('C:\\Users\\vagrant\\AppData\\Roaming\\Boxstarter\\BoxstarterShell.ps1') do
   it { should exist }
  end
end
