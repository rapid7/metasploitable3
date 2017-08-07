# Metasploitable3

Metasploitable3 is a VM that is built from the ground up with a large amount of security vulnerabilities. It is intended to be used as a target for testing exploits with [metasploit](https://github.com/rapid7/metasploit-framework).

Metasploitable3 is released under a BSD-style license. See COPYING for more details.

## Building Metasploitable 3 for PenTesting
System Requirements:
* OS capable of running all of the required applications listed below
* VT-x/AMD-V Supported Processor recommended
* 35 GB Available space on drive
* 4.5 GB RAM

Requirements:

* [Packer](https://www.packer.io/intro/getting-started/install.html)
* [Vagrant](https://www.vagrantup.com/docs/installation/) NOTE: Currently 1.9.1 is recommended as there are build issues with newer versions.
* [Vagrant Reload Plugin](https://github.com/aidanns/vagrant-reload#installation)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* Internet connection

To build automatically:

1. Run the build_win2008.sh script if using bash, or build_win2008.ps1 if using Windows.
2. If the command completes successfully, run 'vagrant up'.
3. When this process completes, you should be able to open the VM within VirtualBox and login. The default credentials are U: vagrant and P: vagrant.

To build manually:

1. Clone this repo and navigate to the main directory.
2. Run the command `vagrant box add jbarnett-r7/metasploitable3-win2k8`. This will download the 6.5+ GB box file from Vagrant cloud. This may take a while depending on your Internet connection.
3. To start the VM, run the command `vagrant up`. This will start up the VM network. This takes about 5-10 minutes.
4. Once this process completes, you can open up the VM within VirtualBox and login. The default credentials are U: vagrant and P: vagrant.

## Vulnerabilities
* [See the wiki page](https://github.com/rapid7/metasploitable3/wiki/Vulnerabilities)

## More Information
The wiki has a lot more detail and serves as the main source of documentation. Please [check it out](https://github.com/rapid7/metasploitable3/wiki/).

## Building Metasploitable 3 for Development
System Requirements:
* OS capable of running all of the required applications listed below
* VT-x/AMD-V Supported Processor recommended
* 35 GB Available space on drive
* 4.5 GB RAM

Requirements:

* [Packer](https://www.packer.io/intro/getting-started/install.html)
* [Vagrant](https://www.vagrantup.com/docs/installation/) NOTE: Currently 1.9.1 is recommended as there are build issues with newer versions.
* [Vagrant Reload Plugin](https://github.com/aidanns/vagrant-reload#installation)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* Internet connection

To build:

1. Clone this repo and navigate to the main directory.
2. Build the base VM image by running `packer build --only=<provider> packer/templates/windows_2008_r2.json` where `<provider>` is your preferred virtualization platform. Currently `virtualbox-iso` and `vmware-iso` are supported. This will take a while the first time you run it since it has to download the OS installation ISO.
3. After the base Vagrant box is created you need to add it to your Vagrant environment. This can be done with the command `vagrant box add packer/builds/windows_2008_r2_<provider>_<version>.box --name=metasploitable3-win2k8`.
4. Use `vagrant plugin install vagrant-reload` to install the reload vagrant provisioner if you haven't already.
5. To start the VM, run the command `vagrant up`. This will start up the VM and run all of the installation and configuration scripts necessary to set everything up. This takes about 20 minutes.
6. Once this process completes, you can open up the VM within VirtualBox and login. The default credentials are U: vagrant and P: vagrant.

## Acknowledgements
The Windows portion of this project was based off of GitHub user [joefitzgerald's](https://github.com/joefitzgerald) [packer-windows](https://github.com/joefitzgerald/packer-windows) project.
The Packer templates, original Vagrantfile, and installation answer files were used as the base template and built upon for the needs of this project.
