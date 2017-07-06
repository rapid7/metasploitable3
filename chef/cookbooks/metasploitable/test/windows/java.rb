control "java" do
  title "Check Java installation"
  desc "Check if java is installed. Checkout the installation script at /scripts/chocolatey_installs/java.bat"

  describe file('C:\\Program Files\\Java\\jre1.8.0_131\\bin\\java.exe') do
   it { should exist }
  end

  describe file('C:\\Program Files\\Java\\jdk1.8.0_131\\bin\\java.exe') do
   it { should exist }
  end

  describe command('java -showversion') do
   its(:exit_status) { should eq 1 }
  end
end
