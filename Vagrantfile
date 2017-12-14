# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "ub1404" do |ub1404|
    ub1404.vm.box = "metasploitable3-ub1404"
    ub1404.vm.hostname = "metasploitable3-ub1404"
    config.ssh.username = 'vagrant'
    config.ssh.password = 'vagrant'

    ub1404.vm.network "private_network", ip: '172.28.128.3'

    ub1404.vm.provider "virtualbox" do |v|
      v.name = "Metasploitable-ub1404"
      v.memory = 2048
    end
  end

  config.vm.define "win2k8" do |win2k8|
    # Base configuration for the VM and provisioner
    win2k8.vm.box = "metasploitable3-win2k8"
    win2k8.vm.hostname = "metasploitable3-win2k8"
    win2k8.vm.communicator = "winrm"
    win2k8.winrm.retry_limit = 60
    win2k8.winrm.retry_delay = 10

    win2k8.vm.network "private_network", type: "dhcp"

    # Configure Firewall to open up vulnerable services
    case ENV['MS3_DIFFICULTY']
      when 'easy'
        config.vm.provision :shell, path: "scripts/configs/disable_firewall.bat"
      else
        win2k8.vm.provision :shell, path: "scripts/configs/enable_firewall.bat"
        win2k8.vm.provision :shell, path: "scripts/configs/configure_firewall.bat"
    end

    # Insecure share from the Linux machine
    win2k8.vm.provision :shell, path: "scripts/installs/install_share_autorun.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
    win2k8.vm.provision :shell, path: "scripts/installs/setup_linux_share.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\tmp\\vagrant-shell.bat" # Hack for this bug: https://github.com/mitchellh/vagrant/issues/7614
  end
end
