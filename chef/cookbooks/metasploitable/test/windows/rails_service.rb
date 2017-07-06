control "rails_service" do
  title "Rails Service"
  desc "Check if Rails service is correctly installed. Setup script available at /scripts/installs/install_rails_service.bat"

  describe file('C:\\Program Files\\Rails_Server\\Gemfile') do
   it { should exist }
  end

  describe file('C:\\Program Files\\Rails_Server\\start_rails_server.bat') do
   it { should exist }
  end

  describe command('netstat -aob | findstr :3000') do
   its('stdout') { should match "LISTENING" }
  end

  describe command('schtasks /Query /tn rails') do
   its('stdout') { should match "Ready" }
  end
end
