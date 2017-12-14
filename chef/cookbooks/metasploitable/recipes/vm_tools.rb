#
# Cookbook:: metasploitable
# Recipe:: vm_tools
#
# Copyright:: 2017, Rapid7, All Rights Reserved.

if node['virtualization']['system'].match /vbox/
  # This assumes the VBoxGuestAdditions.iso was added to the user's home folder in Packer
  bash "Install VirtualBox Guest Tools" do
    code <<-EOH
      mount /home/vagrant/VBoxGuestAdditions.iso /mnt
      cd /mnt
      ./VBoxLinuxAdditions.run
    EOH
  end
end