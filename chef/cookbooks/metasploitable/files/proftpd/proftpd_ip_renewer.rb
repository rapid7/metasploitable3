#!/usr/bin/env ruby

#
# This script will update ProFTPd's DefaultAddress setting in the config file
# when the IP changes.
#
# You should comebine systemd to make sure this things automatically updates
# ProFTPd as soon as it starts. The script:
#
# [Unit]
#Description=Foo
#
# [Service]
# ExecStart=rvm-shell -c /opt/proftpd/proftp_ip_renewer.rb

# [Install]
# WantedBy=multi-user.target
#

require 'socket'

class ProFTPIPRenewer

  class Error < RuntimeError; end

  # The config file to update
  CONFIG_PATH = '/opt/proftpd/etc/proftpd.conf'

  # Number of seconds to wait before we try to update again
  WAIT_TIME   = 3

  # The kind of private IP prefix we are looking for to update
  # The Metasploitable3 private IP always starts with 10-something.
  EXPECTED_IP_PREFIX = '10'

  def initialize
    unless config_exists?
      raise ProFTPIPRenewer::Error, "#{CONFIG_PATH} not found"
    end

    last_known_ip = get_default_address_from_config

    unless last_known_ip
      puts "* There is no DefaultAddress in proftpd.conf. We are going to create one."
      init_default_address_to_config
      last_known_ip = get_default_address_from_config
    end
  end

  def read_config
    File.read(CONFIG_PATH)
  end

  def init_default_address_to_config
    current_ip = get_private_ip
    value = "\nDefaultAddress #{current_ip}\n"
    File.open(CONFIG_PATH, 'ab') do |f|
      f.write(value)
    end
  end

  def get_default_address_from_config
    config = read_config
    config.scan(/DefaultAddress (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/).flatten.first
  end

  def get_private_ip
    ip = Socket.ip_address_list.select { |addr| addr.ip_address =~ /^#{EXPECTED_IP_PREFIX}\./}.first
    if ip
      ip.ip_address
    else
      puts "* The desired IP is not found. We are falling back to 127.0.0.1."
      '127.0.0.1'
    end
  end

  def config_exists?
    File.exists?(CONFIG_PATH)
  end

  def update_ip_address
    config = read_config
    new_config = ''
    changed = false
    current_ip = get_private_ip

    config.each_line do |line|
      if line =~ /DefaultAddress (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/
        if $1 != current_ip
          changed = true
          puts "* IP has changed to: #{current_ip}."
          new_config << "DefaultAddress #{current_ip}\n"
        end
      else
        new_config << line
      end
    end

    if changed
      File.write(CONFIG_PATH, new_config)
      puts "* #{CONFIG_PATH} updated"
    end
  end

  def restart_proftpd
    puts "* Restarting ProFTPd"
    puts `service proftpd stop`
    puts `service proftpd start`
  end

  def start
    while true
      update_ip_address
      sleep WAIT_TIME
    end
  end

end

def main
  begin
    ip_renewer = ProFTPIPRenewer.new
    ip_renewer.start
  rescue ProFTPIPRenewer::Error => e
    puts "* Error: #{e.message}"
  end
end

if __FILE__ == $PROGRAM_NAME
  main
end