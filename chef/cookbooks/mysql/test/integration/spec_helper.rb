# MySQL Client bin path
#
def mysql_bin
  case os[:family]
  when 'smartos'
    '/opt/local/bin/mysql'
  when 'solaris'
    '/opt/omni/bin/mysql'
  else
    '/usr/bin/mysql'
  end
end

# MySQL Server binary path
#
def mysqld_bin(version = nil)
  case os[:family]
  when 'solaris'
    "/opt/mysql#{version.delete('.')}/bin/mysqld"
  when 'smartos'
    '/opt/local/bin/mysqld'
  when 'redhat'
    version == '5.1' ? '/usr/libexec/mysqld' : '/usr/sbin/mysqld'
  else
    '/usr/sbin/mysqld'
  end
end

# Check MySQL Client
#
def check_mysql_client(version)
  lib_name = 'libmysqlclient.so'
  version_short = version.delete('.')

  lib_name = "libmysql#{version_short}client.so" if os[:family] == 'suse'

  # Binary
  describe file(mysql_bin) do
    it { should exist }
  end

  # Version
  describe command("#{mysql_bin} --version") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/Distrib #{version}/) }
    its(:stderr) { should eq '' }
  end

  # Shared lib
  describe command('ldconfig -p') do
    its(:stdout) { should match(/#{lib_name}/) }
  end

  # For some reasons there is no devel lib for community server in OSS-update repo
  return if os[:family] == 'suse'

  # Header file
  describe file('/usr/include/mysql/mysql.h') do
    it { should exist }
  end
end

# Check MySQL server version
#
def check_mysql_server(version)
  mysqld = mysqld_bin(version)
  # Binary
  describe file(mysqld) do
    it { should exist }
  end

  # Version
  describe command("#{mysqld} --version") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/Ver #{version}/) }
    its(:stderr) { should eq '' }
  end
end

# Return MySQL query shell command
#
def mysql_query(query, root_pass, host = '127.0.0.1', port = 3006, database = 'mysql')
  <<-EOF
#{mysql_bin} \
-h #{host} \
-P #{port} \
-u root \
-p#{Shellwords.escape(root_pass)} \
-D #{database} \
-e "#{query}"
  EOF
end

# Check single instance of MySQL
#
def check_mysql_server_instance(port = '3306', password = 'ilikerandompasswords')
  mysql_cmd_1 = mysql_query("SELECT Host,User FROM mysql.user WHERE User='root' AND Host='127.0.0.1';", password, '127.0.0.1', port)
  mysql_cmd_2 = mysql_query("SELECT Host,User FROM mysql.user WHERE User='root' AND Host='localhost';", password, '127.0.0.1', port)

  describe command(mysql_cmd_1) do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/| 127.0.0.1 | root |/) }
  end

  describe command(mysql_cmd_2) do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/| localhost | root |/) }
  end
end

# Check Master-Slave configuration defined by mysql_test::smoke recipe
#
def check_master_slave
  root_pass = 'MyPa$$word\Has_"Special\'Chars%!'
  root_pass_slave = 'An0th3r_Pa%%w0rd!'

  mysql_cmd_1 = mysql_query('SELECT * FROM table1', root_pass_slave, '127.0.0.1', 3307, 'databass')
  mysql_cmd_2 = mysql_query('SELECT * FROM table1', root_pass_slave, '127.0.0.1', 3308, 'databass')

  describe command(mysql_cmd_1) do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/awesome/) }
  end

  describe command(mysql_cmd_2) do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/awesome/) }
  end

  check_mysql_server_instance(3306, root_pass)
  check_mysql_server_instance(3307, root_pass_slave)
  check_mysql_server_instance(3308, root_pass_slave)
end
