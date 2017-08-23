Vagrant.configure("2") do |config|
    config.vm.box = "mtest"
    config.vm.hostname = "metasploitable3"
    config.vm.communicator = "winrm"
    config.winrm.retry_limit = 60
    config.winrm.retry_delay = 10

    config.vm.network "private_network", type: "dhcp"

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
    end
end
