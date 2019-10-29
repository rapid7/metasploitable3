module MysqlCookbook
  module HelpersBase
    require 'shellwords'

    def el6?
      return true if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 6
      false
    end

    def el7?
      return true if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 7
      false
    end

    def wheezy?
      return true if node['platform'] == 'debian' && node['platform_version'].to_i == 7
      false
    end

    def jessie?
      return true if node['platform'] == 'debian' && node['platform_version'].to_i == 8
      false
    end

    def stretch?
      return true if node['platform'] == 'debian' && node['platform_version'].to_i == 9
      false
    end

    def trusty?
      return true if node['platform'] == 'ubuntu' && node['platform_version'] == '14.04'
      return true if node['platform'] == 'linuxmint' && node['platform_version'] =~ /^17\.[0-9]$/
      false
    end

    def xenial?
      return true if node['platform'] == 'ubuntu' && node['platform_version'] == '16.04'
      false
    end

    def defaults_file
      "#{etc_dir}/my.cnf"
    end

    def default_data_dir
      return "/var/lib/#{mysql_name}" if node['os'] == 'linux'
      return "/opt/local/lib/#{mysql_name}" if node['os'] == 'solaris2'
      return "/var/db/#{mysql_name}" if node['os'] == 'freebsd'
    end

    def default_error_log
      "#{log_dir}/error.log"
    end

    def default_pid_file
      "#{run_dir}/mysqld.pid"
    end

    def default_major_version
      # rhelish
      return '5.1' if el6?
      return '5.6' if el7?
      return '5.6' if node['platform'] == 'amazon'

      # debian
      return '5.5' if wheezy?
      return '5.5' if jessie?

      # ubuntu
      return '5.5' if trusty?
      return '5.7' if xenial?

      # misc
      return '5.6' if node['platform'] == 'freebsd'
      return '5.6' if node['platform'] == 'fedora'
      return '5.6' if node['platform_family'] == 'suse'
    end

    def major_from_full(v)
      v.split('.').shift(2).join('.')
    end

    def mysql_name
      "mysql-#{instance}"
    end

    def default_socket_file
      "#{run_dir}/mysqld.sock"
    end

    def default_client_package_name
      return ['mysql', 'mysql-devel'] if major_version == '5.1' && el6?
      return ['mysql55', 'mysql55-devel.x86_64'] if major_version == '5.5' && node['platform'] == 'amazon'
      return ['mysql56', 'mysql56-devel.x86_64'] if major_version == '5.6' && node['platform'] == 'amazon'
      return ['mysql-client-5.5', 'libmysqlclient-dev'] if major_version == '5.5' && node['platform_family'] == 'debian'
      return ['mysql-client-5.6', 'libmysqlclient-dev'] if major_version == '5.6' && node['platform_family'] == 'debian'
      return ['mysql-client-5.7', 'libmysqlclient-dev'] if major_version == '5.7' && node['platform_family'] == 'debian'
      return 'mysql-community-server-client' if major_version == '5.6' && node['platform_family'] == 'suse'
      ['mysql-community-client', 'mysql-community-devel']
    end

    def default_server_package_name
      return 'mysql-server' if major_version == '5.1' && el6?
      return 'mysql55-server' if major_version == '5.5' && node['platform'] == 'amazon'
      return 'mysql56-server' if major_version == '5.6' && node['platform'] == 'amazon'
      return 'mysql-server-5.5' if major_version == '5.5' && node['platform_family'] == 'debian'
      return 'mysql-server-5.6' if major_version == '5.6' && node['platform_family'] == 'debian'
      return 'mysql-server-5.7' if major_version == '5.7' && node['platform_family'] == 'debian'
      return 'mysql-community-server' if major_version == '5.6' && node['platform_family'] == 'suse'
      'mysql-community-server'
    end

    def socket_dir
      File.dirname(socket)
    end

    def run_dir
      return "#{prefix_dir}/var/run/#{mysql_name}" if node['platform_family'] == 'rhel'
      return "/run/#{mysql_name}" if node['platform_family'] == 'debian'
      "/var/run/#{mysql_name}"
    end

    def prefix_dir
      return "/opt/mysql#{pkg_ver_string}" if node['platform_family'] == 'omnios'
      return '/opt/local' if node['platform_family'] == 'smartos'
      return "/opt/rh/#{scl_name}/root" if scl_package?
    end

    def scl_name
      return unless node['platform_family'] == 'rhel'
      return 'mysql51' if version == '5.1' && node['platform_version'].to_i == 5
      return 'mysql55' if version == '5.5' && node['platform_version'].to_i == 5
    end

    def scl_package?
      return unless node['platform_family'] == 'rhel'
      return true if version == '5.1' && node['platform_version'].to_i == 5
      return true if version == '5.5' && node['platform_version'].to_i == 5
      false
    end

    def etc_dir
      return "/opt/mysql#{pkg_ver_string}/etc/#{mysql_name}" if node['platform_family'] == 'omnios'
      return "#{prefix_dir}/etc/#{mysql_name}" if node['platform_family'] == 'smartos'
      "#{prefix_dir}/etc/#{mysql_name}"
    end

    def base_dir
      prefix_dir || '/usr'
    end

    def system_service_name
      return 'mysql51-mysqld' if node['platform_family'] == 'rhel' && scl_name == 'mysql51'
      return 'mysql55-mysqld' if node['platform_family'] == 'rhel' && scl_name == 'mysql55'
      return 'mysqld' if node['platform_family'] == 'rhel'
      return 'mysqld' if node['platform_family'] == 'fedora'
      'mysql' # not one of the above
    end

    def v56plus
      return false if version.split('.')[0].to_i < 5
      return false if version.split('.')[1].to_i < 6
      true
    end

    def v57plus
      return false if version.split('.')[0].to_i < 5
      return false if version.split('.')[1].to_i < 7
      true
    end

    def default_include_dir
      "#{etc_dir}/conf.d"
    end

    def log_dir
      return "/var/adm/log/#{mysql_name}" if node['platform_family'] == 'omnios'
      "#{prefix_dir}/var/log/#{mysql_name}"
    end

    def lc_messages_dir; end

    def init_records_script
      # Note: shell-escaping passwords in a SQL file may cause corruption - eg
      # mysql will read \& as &, but \% as \%. Just escape bare-minimum \ and '
      sql_escaped_password = root_password.gsub('\\') { '\\\\' }.gsub("'") { '\\\'' }

      <<-EOS
        set -e
        rm -rf /tmp/#{mysql_name}
        mkdir /tmp/#{mysql_name}

        cat > /tmp/#{mysql_name}/my.sql <<-'EOSQL'
UPDATE mysql.user SET #{password_column_name}=PASSWORD('#{sql_escaped_password}')#{password_expired} WHERE user = 'root';
DELETE FROM mysql.user WHERE USER LIKE '';
DELETE FROM mysql.user WHERE user = 'root' and host NOT IN ('127.0.0.1', 'localhost');
FLUSH PRIVILEGES;
DELETE FROM mysql.db WHERE db LIKE 'test%';
DROP DATABASE IF EXISTS test ;
EOSQL

       #{db_init}
       #{record_init}

       while [ ! -f #{pid_file} ] ; do sleep 1 ; done
       kill `cat #{pid_file}`
       while [ -f #{pid_file} ] ; do sleep 1 ; done
       rm -rf /tmp/#{mysql_name}
       EOS
    end

    def password_column_name
      return 'authentication_string' if v57plus
      'password'
    end

    def root_password
      if initial_root_password == ''
        Chef::Log.info('Root password is empty')
        return ''
      end
      initial_root_password
    end

    def password_expired
      return ", password_expired='N'" if v57plus
      ''
    end

    def db_init
      return mysqld_initialize_cmd if v57plus
      mysql_install_db_cmd
    end

    def mysql_install_db_bin
      return "#{base_dir}/scripts/mysql_install_db" if node['platform_family'] == 'omnios'
      return "#{prefix_dir}/bin/mysql_install_db" if node['platform_family'] == 'smartos'
      'mysql_install_db'
    end

    def mysql_install_db_cmd
      cmd = mysql_install_db_bin
      cmd << " --defaults-file=#{etc_dir}/my.cnf"
      cmd << " --datadir=#{data_dir}"
      cmd << ' --explicit_defaults_for_timestamp' if v56plus && !v57plus
      return "scl enable #{scl_name} \"#{cmd}\"" if scl_package?
      cmd
    end

    def mysqladmin_bin
      return "#{prefix_dir}/bin/mysqladmin" if node['platform_family'] == 'smartos'
      return 'mysqladmin' if scl_package?
      "#{prefix_dir}/usr/bin/mysqladmin"
    end

    def mysqld_bin
      return "#{prefix_dir}/libexec/mysqld" if node['platform_family'] == 'smartos'
      return "#{base_dir}/bin/mysqld" if node['platform_family'] == 'omnios'
      return '/usr/sbin/mysqld' if node['platform_family'] == 'fedora' && v56plus
      return '/usr/libexec/mysqld' if node['platform_family'] == 'fedora'
      return 'mysqld' if scl_package?
      "#{prefix_dir}/usr/sbin/mysqld"
    end

    def mysqld_initialize_cmd
      cmd = mysqld_bin
      cmd << " --defaults-file=#{etc_dir}/my.cnf"
      cmd << ' --initialize'
      cmd << ' --explicit_defaults_for_timestamp' if v56plus
      return "scl enable #{scl_name} \"#{cmd}\"" if scl_package?
      cmd
    end

    def mysqld_safe_bin
      return "#{prefix_dir}/bin/mysqld_safe" if node['platform_family'] == 'smartos'
      return "#{base_dir}/bin/mysqld_safe" if node['platform_family'] == 'omnios'
      return 'mysqld_safe' if scl_package?
      "#{prefix_dir}/usr/bin/mysqld_safe"
    end

    def record_init
      cmd = v56plus ? mysqld_bin : mysqld_safe_bin
      cmd << " --defaults-file=#{etc_dir}/my.cnf"
      cmd << " --init-file=/tmp/#{mysql_name}/my.sql"
      cmd << ' --explicit_defaults_for_timestamp' if v56plus
      cmd << ' &'
      return "scl enable #{scl_name} \"#{cmd}\"" if scl_package?
      cmd
    end
  end
end
