$ErrorActionPreference = "Stop"

$virtualBoxMinVersion = "6.1.0"
$packerMinVersion = "1.6.0"
$vagrantMinVersion = "1.9.0"
$vagrantreloadMinVersion = "0.0.1"
$packer = "packer.exe"
$expectedVBoxLocation = "C:\Program Files\Oracle\VirtualBox"
$expectedVagrantLocation = "C:\Program Files\Vagrant\bin"

function CompareVersions ($actualVersion, $expectedVersion, $exactMatch = $False) {
    If ($exactMatch) {
        If ($actualVersion -eq $expectedVersion) {
            return $True
        } else {
            return $False
        }
    }

    $actualVersion = $actualVersion.split(".")
    $expectedVersion = $expectedVersion.split(".")

    for($i=0; $i -lt $expectedVersion.length; $i++) {
        If([INT]$actualVersion[$i] -gt [INT]$expectedVersion[$i]) {
            return $True
        }

        If([INT]$actualVersion[$i] -lt [INT]$expectedVersion[$i]) {
            return $False
        }
    }
    return $True
}

Write-Host ""

If (Test-Path "$expectedVBoxLocation\VBoxManage.exe") {

    $vboxVersion = cmd.exe /c "$expectedVBoxLocation\VBoxManage.exe" -v
    $vboxVersion = $vboxVersion.split("r")[0].Trim()

} else {

    Write-Host "VirtualBox is not installed (or not in the expected location of $expectedVBoxLocation\)"
    Write-Host "Please download and install it from https://www.virtualbox.org/"
    exit

}

If (CompareVersions -actualVersion $vboxVersion -expectedVersion $virtualBoxMinVersion -exactMatch $False) {

    Write-Host "Compatible version of VirtualBox found."

} else {

    Write-Host "A compatible version of VirtualBox was not found."
    Write-Host "Current Version=[$vboxVersion], Minimum Version=[$virtualBoxMinVersion]"
    Write-Host "Please download and install it from https://www.virtualbox.org/"
    exit

}

$packerVersion = cmd.exe /c $packer -v
$packerVersion = $packerVersion -replace 'Packer v', ''

If (CompareVersions -actualVersion $packerVersion -expectedVersion $packerMinVersion) {

    Write-Host "Compatible version of Packer found."

} else {

    Write-Host "Could not find a compatible version of Packer. Please download it from https://www.packer.io/downloads.html and add it to your PATH."
    exit

}

If (Test-Path "$expectedVagrantLocation\vagrant.exe") {

    $vagrantVersion = cmd.exe /c "vagrant" -v
    $vagrantVersion = $vagrantVersion.split(" ")[1].Trim()

} else {

    Write-Host "Vagrant is not installed (or not in the expected location of $expectedVagrantLocation\)"
    Write-Host "Please download and install it from https://www.vagrantup.com/downloads.html/"
    exit

}

If (CompareVersions -actualVersion $vagrantVersion -expectedVersion $vagrantMinVersion) {

    Write-Host "Compatible version of Vagrant found."

} else {

    Write-Host "Could not find a compatible version of Vagrant at C:\HashiCorp\Vagrant\bin\. Please download and install it from https://www.vagrantup.com/downloads.html."
    exit

}

$vagrantPlugins = cmd.exe /c "vagrant plugin list" | select-string -pattern "vagrant-reload"

If (![string]::IsNullOrEmpty($vagrantPlugins)) {

    $vagrantPlugins = $vagrantPlugins.ToString().Trim()
    $vagrantreloadVersion = $vagrantPlugins.Replace("(", "")
    $vagrantreloadVersion = $vagrantreloadVersion.Replace(")", "")
    $vagrantreloadVersion = $vagrantreloadVersion.split(" ")[1]

    If (CompareVersions -actualVersion $vagrantreloadVersion -expectedVersion $vagrantreloadMinVersion) {

        Write-Host "Compatible version of vagrant-reload plugin found."

    }

} else {

    Write-Host "Could not find a compatible version of vagrant-reload plugin. Attempting to install..."
    cmd.exe /c "vagrant plugin install vagrant-reload"

    # Hacky version of Try-Catch for non-terminating errors.
    # See http://stackoverflow.com/questions/1142211/try-catch-does-not-seem-to-have-an-effect

    if($?) {
        Write-Host "The vagrant-reload plugin was successfully installed."
    } else {
        throw "Error installing vagrant-reload plugin. Please check the output above for any error messages."
    }

}

function InstallBox($os_full, $os_short)
{
    $boxversion = Get-Content .\packer\templates\$os_full.json | Select-String -Pattern "box_version" | Select-String -Pattern "[0-9]\.[0-9]\.[0-9]+"
    $boxversion = $boxversion.toString().trim().split('"')[3]

    Write-Host "Building metasploitable3-$os_short Vagrant box..."

    If (Test-Path "packer\builds\$($os_full)_virtualbox_$boxversion.box") {

        Write-Host "It looks like the Vagrant box already exists. Skipping the Packer build."

    } else {

        cmd.exe /c $packer build --only=virtualbox-iso packer\templates\$os_full.json

        if($?) {
          Write-Host "Box successfully built by Packer."
        } else {
         throw "Error building the Vagrant box using Packer. Please check the output above for any error messages."
        }
    }

    Write-Host "Attempting to add metasploitable3-$os_short box to Vagrant..."
    $vagrant_box_list = cmd.exe /c "vagrant box list"

    If ($vagrant_box_list -match "rapid7/metasploitable3-$os_short") {
        Write-Host "rapid7/metasploitable3-$os_short already found in Vagrant box repository. Skipping the addition to Vagrant."
    } else {

        cmd.exe /c vagrant box add packer\builds\$($os_full)_virtualbox_$boxversion.box --name rapid7/metasploitable3-$os_short

        if($?) {
            Write-Host "rapid7/metasploitable3-$os_short box successfully added to Vagrant."
        } else {
            throw "Error adding metasploitable3-$os_short box to Vagrant. See the above output for any error messages."
        }
    }
}

Write-Host "All requirements found. Proceeding..."

if ($args.Length -eq 0) {
    $option = Read-Host -Prompt 'No box name passed as input. Build both the boxes ? (y/n)';
    if ($option -eq 'y') {
        InstallBox -os_full "windows_2008_r2" -os_short "win2k8"
        InstallBox -os_full "ubuntu_1404" -os_short "ub1404"
    } else {
        Write-Host "To build metasploitable boxes separately, use the following commands:"
        Write-Host "- .\build.ps1 windows2008"
        Write-Host "- .\build.ps1 ubuntu1404"
    }
} ElseIf ($args.Length -eq 1) {
    if ($args -eq "windows2008") {
        InstallBox -os_full "windows_2008_r2" -os_short "win2k8"
    } ElseIf ($args -eq "ubuntu1404") {
        InstallBox -os_full "ubuntu_1404" -os_short "ub1404"
    } else {
        Write-Host "Invalid OS. Valid options are 'ubuntu1404' and 'windows2008'"
    }
}

Write-Host ""
