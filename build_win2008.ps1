$ErrorActionPreference = "Stop"

$virtualBoxMinVersion = "5.1.10"
$vagrantMinVersion = "1.9.0"
$vagrantreloadMinVersion = "0.0.1"

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

    for($i=0; $i -le $expectedVersion.length; $i++) {
        If([INT]$actualVersion[$i] -gt [INT]$expectedVersion[$i]) {
            return $True
        }

        If([INT]$actualVersion[$i] -lt [INT]$expectedVersion[$i]) {
            return $False
        }
    }
    return $True
}

$expectedVBoxLocation = "C:\Program Files\Oracle\VirtualBox"
If ($(Test-Path "$expectedVBoxLocation\VBoxManage.exe") -eq $True) {
    $vboxVersion = cmd.exe /c "$expectedVBoxLocation\VBoxManage.exe" -v
    $vboxVersion = $vboxVersion.split("r")[0]
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

If ($(Test-Path "C:\HashiCorp\Vagrant\bin\vagrant.exe") -eq $True) {
    $vagrantVersion = cmd.exe /c "vagrant" -v
    $vagrantVersion = $vagrantVersion.split(" ")[1]
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

Write-Host "All requirements found. Proceeding..."

$vagrant_box_list = cmd.exe /c "vagrant box list" | select-string -pattern "jbarnett-r7/metasploitable3-win2k8"

If ($vagrant_box_list) { $vagrant_box_list = $vagrant_box_list.ToString().Trim() }

If ($vagrant_box_list -eq "jbarnett-r7/metasploitable3-win2k8") {
    Write-Host "jbarnett-r7/metasploitable3-win2k8 already found in Vagrant box repository. Skipping the addition to Vagrant."
} else {
    Write-Host "Attempting to add the box to Vagrant. This may take a while..."
    cmd.exe /c vagrant box add jbarnett-r7/metasploitable3-win2k8

    if($?) {
        Write-Host "Box successfully added to Vagrant."
    } else {
        throw "Error adding box to Vagrant. See the above output for any error messages."
    }
}

Write-Host "SUCCESS: Run 'vagrant up' to provision and start metasploitable3."
Write-Host "NOTE: The VM will need Internet access to provision properly."