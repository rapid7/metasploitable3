If ($(Test-Path "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe") -eq $True -and $(cmd.exe /c "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" -v).split(".")[0] -ge "5") {
    Write-Host "Compatible version of VirtualBox found."
} else {
    Write-Host "Could not find a compatible version of VirtualBox at C:\Program Files\Oracle\VirtualBox\. Please download and install it from https://www.virtualbox.org/wiki/Downloads."
    exit
}

If ($(cmd.exe /c "packer" -v) -eq "0.10.1") {
    Write-Host "Compatible version of packer found."
} else {
    Write-Host "Could not find a compatible version of packer. Please download it from https://www.packer.io/downloads.html and install it to your PATH."
    exit
}

If ($(Test-Path "C:\HashiCorp\Vagrant\bin\vagrant.exe") -eq $True -and $(cmd.exe /c "vagrant" -v).split(" ")[1] -eq "1.8.5") {
    Write-Host "Compatible version of Vagrant found."
} else {
    Write-Host "Could not find a compatible version of Vagrant at C:\HashiCorp\Vagrant\bin\. Please download and install it from https://www.vagrantup.com/downloads.html."
    exit
}

$vagrant_plugins = cmd.exe /c "vagrant plugin list" | select-string -pattern "vagrant-reload"

If ($vagrant_plugins) { $vagrant_plugins = $vagrant_plugins.ToString().Trim() }

If ($vagrant_plugins -eq "vagrant-reload (0.0.1)") {
    Write-Host "Compatible version of vagrant-reload plugin found."
} else {
    Write-Host "Could not find a compatible version of vagrant-reload plugin. Attempting to install..."
    cmd.exe /c "vagrant plugin install vagrant-reload"
}

Write-Host "All requirements found. Proceeding..."

If ($(Test-Path "windows_2008_r2_virtualbox.box") -eq $True) {
    Write-Host "It looks like the vagrant box already exists. Skipping the Packer build."
} else {
    echo "Building the Vagrant box..."
    cmd.exe /c packer build windows_2008_r2.json
}

echo "Attempting to add the box to Vagrant..."

$vagrant_box_list = cmd.exe /c "vagrant box list" | select-string -pattern "metasploitable3"

If ($vagrant_box_list) { $vagrant_box_list = $vagrant_box_list.ToString().Trim() }

If ($vagrant_box_list -eq "metasploitable3") {
    Write-Host "metasploitable3 already found in Vagrant box repository. Skipping the addition to Vagrant."
} else {
    cmd.exe /c vagrant box add windows_2008_r2_virtualbox.box --name metasploitable3
    echo "Box successfully added to Vagrant."
}

Write-Host "SUCCESS: Run 'vagrant up' to provision and start metasploitable3."