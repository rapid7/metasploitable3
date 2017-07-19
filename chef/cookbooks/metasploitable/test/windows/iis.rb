control "iis" do
  title "IIS HTTP"
  desc "Checks if the IIS server has started and listening on port 80. Setup script available at /scripts/installs/setup_iis.bat"

  describe port('3389') do
   it { should be_listening }
  end
end
