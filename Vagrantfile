# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Base configuration for the VM and provisioner
  config.vm.box = "metasploitable3"
  config.vm.hostname = "metasploitable3"
  config.vm.communicator = "winrm"

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
  config.vm.provision :shell, path: "scripts/configs/apply_password_settings.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

  # Add users and add to groups
  config.vm.provision :shell, path: "scripts/configs/create_users.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

  # Vulnerability - Unpatched IIS and FTP
  config.vm.provision :shell, path: "scripts/installs/setup_iis.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
  config.vm.provision :shell, path: "scripts/installs/setup_ftp_site.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

  # Vulnerability - Setup for Apache Struts
  config.vm.provision :shell, path: "scripts/chocolatey_installs/java.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
  config.vm.provision :shell, path: "scripts/chocolatey_installs/tomcat.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
  config.vm.provision :reload # Hack to reset environment variables
  config.vm.provision :shell, path: "scripts/installs/setup_apache_struts.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

  # Vulnerability - Setup for Glassfish
  config.vm.provision :shell, path: "scripts/installs/setup_glassfish.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
  config.vm.provision :shell, path: "scripts/installs/start_glassfish_service.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

  # Vulnerability - Jenkins (1.8)
  config.vm.provision :shell, path: "scripts/installs/setup_jenkins.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

  # Vulnerability - Wordpress and phpMyAdmin
  config.vm.provision :shell, path: "scripts/chocolatey_installs/vcredist2008.bat" # Visual Studio 2008 redistributable is a requirement for WAMP
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
  config.vm.provision :shell, path: "scripts/installs/install_wamp.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
  config.vm.provision :shell, path: "scripts/installs/start_wamp.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
  config.vm.provision :shell, path: "scripts/installs/install_wordpress.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

  # Vulnerability - JMX
  config.vm.provision :shell, path: "scripts/installs/install_openjdk6.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
  config.vm.provision :shell, path: "scripts/installs/setup_jmx.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

  # Vulnerability - Rails Server
  config.vm.provision :shell, path: "scripts/installs/install_ruby.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
  config.vm.provision :shell, path: "scripts/installs/install_devkit.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
  config.vm.provision :shell, path: "scripts/installs/install_rails_server.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
  config.vm.provision :shell, path: "scripts/installs/setup_rails_server.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
  config.vm.provision :shell, path: "scripts/installs/install_rails_service.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

  # Vulnerability - WebDAV
  config.vm.provision :shell, path: "scripts/installs/setup_webdav.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

  # Vulnerability - MySQL
  config.vm.provision :shell, path: "scripts/installs/setup_mysql.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

  # Vulnerability - ManageEngine Desktop Central
  config.vm.provision :shell, path: "scripts/installs/install_manageengine.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

  # Vulnerability - Axis2
  config.vm.provision :shell, path: "scripts/installs/setup_axis2.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

  # Vulnerability - Chinese caidao.asp backdoor
  config.vm.provision :shell, path: "scripts/installs/install_backdoors.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

  # Configure Firewall to open up vulnerable services
  config.vm.provision :shell, path: "scripts/configs/configure_firewall.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614

  # Configure flags
  config.vm.provision :shell, path: "scripts/installs/install_flags.bat"
  config.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614a
end
