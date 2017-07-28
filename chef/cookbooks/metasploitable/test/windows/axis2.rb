control "axis2" do
  title "Axis 2"
  desc "Check if Axis 2 webapp is installed. Installation script available at /scripts/installs/setup_axis2.bat"

  describe file('C:\\axis2') do
   it { should_not exist }
  end

  describe file('C:\\Program Files\\Apache Software Foundation\\tomcat\\apache-tomcat-8.5.12\\webapps\\axis2') do
   it { should exist }
  end

  describe port('8282') do
   it { should be_listening }
  end
end
