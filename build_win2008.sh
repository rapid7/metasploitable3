#!/bin/bash

min_vagrant_ver="1.8.6"
min_packer_ver="0.10.0"
min_vagrantreload_ver="0.0.1"
packer_bin=packer-io

function compare_versions {
    actual_version=$1
    expected_version=$2
    exact_match=$3

    if $exact_match; then
        if [ "$actual_version" == "$expected_version" ]; then
            return 0
        else
            return 1
        fi
    fi

    IFS='.' read -ra actual_version <<< "$actual_version"
    IFS='.' read -ra expected_version <<< "$expected_version"

    for ((i=0; i < ${#expected_version[@]}; i++))
    do
        if [[ ${actual_version[$i]} -gt ${expected_version[$i]} ]]; then
            return 0
        fi

        if [[ ${actual_version[$i]} -lt ${expected_version[$i]} ]]; then
            return 1
        fi
    done
    return 0
}

if [ $(uname) = "Darwin" ]; then
    if compare_versions $(VBoxManage -v | cut -d'r' -f1) 5.1.6 true; then
        echo "Compatible version of VirtualBox found."
    else
        echo "A compatible version of VirtualBox was not found. Currently only 5.1.6 is supported. Please download and install it from https://www.virtualbox.org/wiki/Download_Old_Builds_5_1."
        exit 1
    fi
fi

if compare_versions $($packer_bin -v) $min_packer_ver false; then
    echo 'Compatible version of packer was found.'
else
    packer_bin=packer
    if compare_versions $($packer_bin -v) $min_packer_ver false; then
        echo "A compatible version of packer was not found. Please install from here: https://www.packer.io/downloads.html"
        exit 1
    fi
fi

if compare_versions $(vagrant -v | cut -d' ' -f2) $min_vagrant_ver false; then
    echo 'Correct version of vagrant was found.'
else
    echo "A compatible version of vagrant was not found. Please download and install it from https://www.virtualbox.org/wiki/Downloads."
    exit 1
fi

if compare_versions $(vagrant plugin list | grep 'vagrant-reload' | cut -d' ' -f2 | tr -d '(' | tr -d ')') $min_vagrantreload_ver false; then
    echo 'Compatible version of vagrant-reload plugin was found.'
else
    echo "A compatible version of vagrant-reload plugin was not found."
    echo "Attempting to install..."
    if vagrant plugin install vagrant-reload; then
        echo "Successfully installed the vagrant-reload plugin."
    else
        echo "There was an error installing the vagrant-reload plugin. Please see the above output for more information."
        exit 1
    fi
fi

echo "All requirements found. Proceeding..."

if ls | grep -q 'windows_2008_r2_virtualbox.box'; then
    echo "It looks like the vagrant box already exists. Skipping the Packer build."
else
    echo "Building the Vagrant box..."
    if $packer_bin build windows_2008_r2.json; then
        echo "Box successfully built by Packer."
    else
        echo "Error building the Vagrant box using Packer. Please check the output above for any error messages."
        exit 1
    fi
fi

echo "Attempting to add the box to Vagrant..."

if vagrant box list | grep -q 'metasploitable3'; then
    echo 'metasploitable3 already found in Vagrant box repository. Skipping the addition to Vagrant.'
    echo "NOTE: If you are having issues, try starting over by doing 'vagrant destroy' and then 'vagrant up'."
else
    if vagrant box add windows_2008_r2_virtualbox.box --name metasploitable3; then
        echo "Box successfully added to Vagrant."
    else
        echo "Error adding box to Vagrant. See the above output for any error messages."
        exit 1
    fi
fi

echo "SUCCESS: Run 'vagrant up' to provision and start metasploitable3."
echo "NOTE: The VM will need Internet access to provision properly."
