#!/bin/bash

if [[ $(VBoxManage -v | cut -d'.' -f1) -ge "5" ]]; then
    echo "Compatible version of VirtualBox found."
else
    echo "A compatible version of VirtualBox was not found. Please download and install it from here: https://www.virtualbox.org/wiki/Downloads"
    exit 1
fi

if packer -v | grep -q '0.10.0'; then
    echo 'Compatible version of packer was found.'
else
    echo "A compatible version of packer was not found. Please install from here: https://www.packer.io/downloads.html"
    exit 1
fi

if vagrant -v | grep -q '1.8.1'; then
    echo 'Correct version of vagrant was found.'
else
    echo "A compatible version of vagrant was not found. At this time only 1.8.1 is supported. Please install from here: https://releases.hashicorp.com/vagrant/1.8.1/"
    exit 1
fi

if vagrant plugin list | grep -q 'vagrant-reload (0.0.1)'; then
    echo 'Compatible version of vagrant-reload plugin was found.'
else
    echo "A compatible version of vagrant-reload plugin was not found."
    echo "Attempting to install..."
    vagrant plugin install vagrant-reload
fi

echo "All requirements found. Proceeding..."

if ls | grep -q 'windows_2008_r2_virtualbox.box'; then
    echo "It looks like the vagrant box already exists. Skipping the Packer build."
else
    echo "Building the Vagrant box..."
    packer build windows_2008_r2.json
fi

echo "Attempting to add the box to Vagrant..."

if vagrant box list | grep -q 'metasploitable3'; then
    echo 'metasploitable3 already found in Vagrant box repository. Skipping the addition to Vagrant.'
else
    vagrant box add windows_2008_r2_virtualbox.box --name metasploitable3
    echo "Box successfully added to Vagrant."
fi

echo "SUCCESS: Run 'vagrant up' to provision and start metasploitable3."
