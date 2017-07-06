control "mysql" do
  title "MySQL"
  desc "Check if MySQL is running properly. Installation script available at /scripts/installs/setup_mysql.bat"

  describe command('sc query wampmysqld') do
   its('stdout') { should match "STATE              : 4  RUNNING" }
  end

  describe command('netstat -aob | findstr :3306') do
   its('stdout') { should match "LISTENING" }
  end
end
