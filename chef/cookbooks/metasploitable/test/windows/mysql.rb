control "mysql" do
  title "MySQL"
  desc "Check if MySQL is running properly. Installation script available at /scripts/installs/setup_mysql.bat"

  describe service('wampmysqld') do
   it { should be_installed }
   it { should be_enabled }
   it { should be_running }
  end

  describe port('3306') do
   it { should be_listening }
  end
end
