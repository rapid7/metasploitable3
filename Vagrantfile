# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Base configuration for the VM and provisioner
  config.vm.box = "metasploitable3"
  config.vm.hostname = "metasploitable3"
  config.vm.communicator = "winrm"

  config.vm.network "private_network", type: "dhcp"

  # Configure Firewall to open up vulnerable services
  case ENV['MS3_DIFFICULTY']
  when 'easy'
    config.vm.provision :shell, path: "scripts/configs/disable_firewall.bat"
  else
    config.vm.provision :shell, path: "scripts/configs/enable_firewall.bat"
    config.vm.provision :shell, path: "scripts/configs/configure_firewall.bat"
  end
end
