# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "win2k8" do |win2k8|
    # Base configuration for the VM and provisioner
    win2k8.vm.box = "metasploitable3"
    win2k8.vm.hostname = "metasploitable3"
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

  config.vm.define "trusty" do |trusty|
    trusty.vm.box = "rsginc/ubuntu64-14-04-1"
    trusty.vm.hostname = "metasploitableUB"

    trusty.vm.network "private_network", ip: '172.28.128.3'

    trusty.vm.provider "virtualbox" do |v|
      v.name = "MetasploitableUB"
      v.memory = 2048
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
      chef.add_recipe "metasploitable::docker"
      chef.add_recipe "metasploitable::samba"
      chef.add_recipe "metasploitable::sinatra"
      chef.add_recipe "metasploitable::unrealircd"
      chef.add_recipe "metasploitable::chatbot"
      chef.add_recipe "metasploitable::payroll_app"
      chef.add_recipe "metasploitable::readme_app"
      chef.add_recipe "metasploitable::cups"
      chef.add_recipe "metasploitable::drupal"
    end
  end
end