control "choco" do
  title "Check chocolatey"
  desc "Checks if chocolatey has been installed successfully"

  describe command('choco --version') do
   its(:exit_status) { should eq 0 }
  end
end
