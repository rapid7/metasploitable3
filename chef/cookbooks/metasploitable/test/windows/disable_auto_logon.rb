control "disable-auto-logon" do
  title "Disable Auto Logon"
  desc "Check if the registry is updated to disable auto logon. Configuration script available at /scripts/configs/disable-auto-logon.bat"

  describe command('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon') do
   its('stdout') { should match ("AutoAdminLogon    REG_SZ    0") }
  end
end
