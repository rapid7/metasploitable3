control "7zip" do
  title "Check 7zip"
  desc "Check if choco installed 7zip. Installation script available at /scripts/chocolatey_installs/7zip.bat"

  describe file('C:\\ProgramData\\chocolatey\\bin\\7z.exe') do
   it { should exist }
  end
end
