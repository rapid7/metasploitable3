control "openjdk6" do
  title "Check OpenJDK 6"
  desc "Checks for the installation of OpenJDK 6. Setup file available at /scripts/installs/setup_openjdk6.bat"

  describe file('C:\\openjdk6\\openjdk-1.6.0-unofficial-b27-windows-amd64') do
   it { should exist }
  end

  describe command('C:\openjdk6\openjdk-1.6.0-unofficial-b27-windows-amd64\jre\bin\java.exe -version') do
   its('stdout') { should match "openjdk version \"1.6.0-unofficial\"" }
  end
end
