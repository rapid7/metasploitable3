control "jmx" do
  title "Check JMX installation"
  desc "Check if the JMX service is correctly installed. Setup script available at /scripts/installs/setup_jmx.bat"

  describe file('C:\\Program Files\\jmx') do
   it { should exist }
  end

  describe file('C:\\Program Files\\jmx\\Hello.class') do
   it { should exist }
  end

  describe file('C:\\Program Files\\jmx\\HelloMBean.class') do
   it { should exist }
  end

  describe file('C:\\Program Files\\jmx\\SimpleAgent.class') do
   it { should exist }
  end

  describe file('C:\\Program Files\\jmx\\jmx.exe') do
   it { should exist }
  end

  describe file('C:\\Program Files\\jmx\\start_jmx.bat') do
   it { should exist }
  end

  describe service('jmx') do
   it { should be_installed }
   it { should be_enabled }
   it { should be_running }
  end

  describe port('1617') do
   it { should be_listening }
  end
end
