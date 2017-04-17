# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "win2k8" do |win2k8|
    # Base configuration for the VM and provisioner
    win2k8.vm.box = "metasploitable3"
    win2k8.vm.hostname = "metasploitable3"
    win2k8.vm.communicator = "winrm"

    win2k8.vm.network "private_network", type: "dhcp"

    # Install Chocolatey
    config.vm.provision :shell, path: "scripts/installs/chocolatey.cmd"
    config.vm.provision :reload # Hack to reset environment variables

    # Install BoxStarter
    config.vm.provision :shell, path: "scripts/installs/install_boxstarter.bat"
    config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

    # Install 7zip
    config.vm.provision :shell, path: "scripts/chocolatey_installs/7zip.bat"
    config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

    # Adjust password policy
    win2k8.vm.provision :shell, path: "scripts/configs/apply_password_settings.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

    # Add users and add to groups
    win2k8.vm.provision :shell, path: "scripts/configs/create_users.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

    # Vulnerability - Unpatched IIS and FTP
    win2k8.vm.provision :shell, path: "scripts/installs/setup_iis.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
    win2k8.vm.provision :shell, path: "scripts/installs/setup_ftp_site.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

    # Vulnerability - Setup for Apache Struts
    win2k8.vm.provision :shell, path: "scripts/chocolatey_installs/java.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
    win2k8.vm.provision :shell, path: "scripts/chocolatey_installs/tomcat.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
    win2k8.vm.provision :reload # Hack to reset environment variables
    win2k8.vm.provision :shell, path: "scripts/installs/setup_apache_struts.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

    # Vulnerability - Setup for Glassfish
    win2k8.vm.provision :shell, path: "scripts/installs/setup_glassfish.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
    win2k8.vm.provision :shell, path: "scripts/installs/start_glassfish_service.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

    # Vulnerability - Jenkins (1.8)
    win2k8.vm.provision :shell, path: "scripts/installs/setup_jenkins.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

    # Vulnerability - Wordpress and phpMyAdmin
    # This must run after the WAMP setup.
    win2k8.vm.provision :shell, path: "scripts/chocolatey_installs/vcredist2008.bat" # Visual Studio 2008 redistributable is a requirement for WAMP
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
    win2k8.vm.provision :shell, path: "scripts/installs/install_wamp.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
    win2k8.vm.provision :shell, path: "scripts/installs/start_wamp.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
    win2k8.vm.provision :shell, path: "scripts/installs/install_wordpress.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

    # Vulnerability - JMX
    win2k8.vm.provision :shell, path: "scripts/installs/install_openjdk6.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
    win2k8.vm.provision :shell, path: "scripts/installs/setup_jmx.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

    # Vulnerability - Rails Server
    win2k8.vm.provision :shell, path: "scripts/installs/install_ruby.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
    win2k8.vm.provision :shell, path: "scripts/installs/install_devkit.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
    win2k8.vm.provision :shell, path: "scripts/installs/install_rails_server.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
    win2k8.vm.provision :shell, path: "scripts/installs/setup_rails_server.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
    win2k8.vm.provision :shell, path: "scripts/installs/install_rails_service.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

    # Vulnerability - WebDAV
    # This must run after the WAMP setup.
    win2k8.vm.provision :shell, path: "scripts/installs/setup_webdav.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

    # Vulnerability - MySQL
    win2k8.vm.provision :shell, path: "scripts/installs/setup_mysql.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

    # Vulnerability - ManageEngine Desktop Central
    win2k8.vm.provision :shell, path: "scripts/installs/install_manageengine.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

    # Vulnerability - Axis2
    # This must run after the Apache Struts setup.
    win2k8.vm.provision :shell, path: "scripts/installs/setup_axis2.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

    # Vulnerability - Common backdoors
    win2k8.vm.provision :shell, path: "scripts/installs/install_backdoors.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

    # Vulnerability - SNMP
    win2k8.vm.provision :shell, path: "scripts/installs/setup_snmp.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

    # Configure Firewall to open up vulnerable services
    case ENV['MS3_DIFFICULTY']
    when 'easy'
      win2k8.vm.provision :shell, path: "scripts/configs/disable_firewall.bat"
    else
      win2k8.vm.provision :shell, path: "scripts/configs/configure_firewall.bat"
    end

    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

    # Vulnerability - ElasticSearch
    # This must run after the firewall rules, because it needs to make some HTTP requests in order to
    # set up the vulnerable state.
    win2k8.vm.provision :shell, path: "scripts/installs/install_elasticsearch.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

    # Insecure share from the Linux machine
    win2k8.vm.provision :shell, path: "scripts/installs/setup_linux_share.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

    # Configure flags
    win2k8.vm.provision :shell, path: "scripts/installs/install_flags.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614a
  end

  config.vm.define "trusty" do |trusty|
    trusty.vm.box = "rsginc/ubuntu64-14-04-1"
    trusty.vm.hostname = "metasploitableUB"

    trusty.vm.network "private_network", ip: '172.28.128.3'

    trusty.vm.provider "virtualbox" do |v|
      v.name = "MetasploitableUB"
      v.memory = 1024
    end

    config.omnibus.chef_version = :latest

    # Provision with Chef Solo
    #
    config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = [ 'chef/cookbooks' ]

      chef.json = { 'metasploitable' => {
                      # Customizations here
                    }
                  }

      chef.add_recipe "metasploitable::mysql"
      chef.add_recipe "metasploitable::apache_continuum"
      chef.add_recipe "metasploitable::apache"
      chef.add_recipe "metasploitable::php_545"
      chef.add_recipe "metasploitable::phpmyadmin"
      chef.add_recipe "metasploitable::proftpd"
      chef.add_recipe "metasploitable::users"
      chef.add_recipe "metasploitable::sinatra"
      chef.add_recipe "metasploitable::docker"
      chef.add_recipe "metasploitable::samba"
      chef.add_recipe "metasploitable::unrealircd"
      chef.add_recipe "metasploitable::chatbot"
    end
  end
end
