control "rails_service" do
  title "Rails Service"
  desc "Check if Rails service is correctly installed. Setup script available at /scripts/installs/install_rails_service.bat"

  describe file('C:\\Program Files\\Rails_Server\\Gemfile') do
   it { should exist }
  end

  describe file('C:\\Program Files\\Rails_Server\\start_rails_server.bat') do
   it { should exist }
  end

  describe port('3000') do
   it { should be_listening }
  end

  describe windows_task('rails') do
   it { should exist }
   it { should be_enabled }
  end
end
