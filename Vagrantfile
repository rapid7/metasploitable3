# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.define "ub1404" do |ub1404|
    ub1404.vm.box = "rapid7/metasploitable3-ub1404"
    ub1404.vm.hostname = "metasploitable3-ub1404"
    config.ssh.username = 'vagrant'
    config.ssh.password = 'vagrant'

    ub1404.vm.network "private_network", ip: '172.28.128.3'

    ub1404.vm.provider "virtualbox" do |v|
      v.name = "Metasploitable3-ub1404"
      v.memory = 2048
    end
    
    config.vm.provider "hyperv" do |h|
      config.vm.boot_timeout = 300
      h.linked_clone = true
      h.memory = 2048
    end
  end

  config.vm.define "win2k8" do |win2k8|
    # Base configuration for the VM and provisioner
    win2k8.vm.box = "rapid7/metasploitable3-win2k8"
    win2k8.vm.hostname = "metasploitable3-win2k8"
    win2k8.vm.communicator = "winrm"
    win2k8.winrm.retry_limit = 60
    win2k8.winrm.retry_delay = 10

    win2k8.vm.network "private_network", type: "dhcp"
    
    config.vm.provider "hyperv" do |h|
      config.vm.boot_timeout = 300
      h.linked_clone = true
      h.memory = 2048
      h.maxmemory = 4096
      config.vm.post_up_message = <<MSG
------------------------------------------------------
Thanks to Vagrant/Hyper-V limitations we can't automatically set
the VM IP addresses.
(https://www.vagrantup.com/docs/hyperv/limitations.html)

Look above for a line like: "ub1404: IP: X.X.X.X"
and change the ip address listed in
 scripts/installs/setup_linux_share.bat
to match this value.
 
Then run:
 'vagrant provision win2k8'
for it to take effect
------------------------------------------------------
MSG
    end


    # Configure Firewall to open up vulnerable services
    case ENV['MS3_DIFFICULTY']
      when 'easy'
        win2k8.vm.provision :shell, inline: "C:\\startup\\disable_firewall.bat"
      else
        win2k8.vm.provision :shell, inline: "C:\\startup\\enable_firewall.bat"
        win2k8.vm.provision :shell, inline: "C:\\startup\\configure_firewall.bat"
    end

    # Insecure share from the Linux machine
    win2k8.vm.provision :shell, inline: "C:\\startup\\install_share_autorun.bat"
    win2k8.vm.provision :shell, inline: "C:\\startup\\setup_linux_share.bat"
    win2k8.vm.provision :shell, inline: "rm C:\\startup\\*" # Cleanup startup scripts

  end
end
