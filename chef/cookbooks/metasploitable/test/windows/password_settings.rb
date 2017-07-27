control "password-settings" do
  title "Password settings"
  desc "Check if the password settings are correctly configured. Configuration script available at /scripts/configs/apply_password_settings.bat"

  describe command('secedit /analyze /db %windir%\securitynew.sdb /cfg C:\vagrant\resources\security_settings\secconfig.cfg /areas SECURITYPOLICY') do
   its(:exit_status) { should eq 1 }
  end
end
