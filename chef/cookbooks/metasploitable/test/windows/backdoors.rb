control "backdoors" do
  title "Backdoors"
  desc "Check if the backdoors are correctly placed. Installation script present at: /scripts/installs/install_backdoors.bat"

  describe file('C:\\inetpub\\wwwroot\\caidao.asp') do
   it { should exist }
  end

  describe file('C:\\wamp\\www\\mma.php') do
   it { should exist }
  end

  describe file('C:\\wamp\\www\\meterpreter.php') do
   it { should exist }
  end
end
