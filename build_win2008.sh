#!/bin/bash

min_vbox_ver="5.1.10"
min_vagrant_ver="1.9.0"

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

# Conditional for platform specific version checks. Some of these might seem redundant since
# there might not be anything actively broken in the dependent software. Keeping it around as
# version upgrades could break things on specific platforms.
if [ $(uname) = "Darwin" ]; then
    vagrant_exact_match=false
elif [ $(uname) = "Linux" ]; then
    vagrant_exact_match=false
fi

if [ -x "$(which VBoxManage)" ] ; then
    current_vbox_ver=$(VBoxManage -v | sed -e 's/r.*//g' -e 's/_.*//g')
    if compare_versions $current_vbox_ver $min_vbox_ver false; then
        echo "Compatible version of VirtualBox found."
    else
        echo "A compatible version of VirtualBox was not found."
        echo "Current Version=[$current_vbox_ver], Minimum Version=[$min_vbox_ver]"
        echo "Please download and install it from https://www.virtualbox.org/"
        exit 1
    fi
else
    echo "VirtualBox is not installed (or not added to the path)."
    echo "Please download and install it from https://www.virtualbox.org/"
    exit 1
fi

if compare_versions $(vagrant -v | cut -d' ' -f2) $min_vagrant_ver $vagrant_exact_match; then
    echo 'Correct version of vagrant was found.'
else
    echo "A compatible version of vagrant was not found. Please download and install it from https://www.vagrantup.com/downloads.html."
    exit 1
fi

echo "All requirements found. Proceeding..."

if vagrant box list | grep -q 'jbarnett-r7/metasploitable3-win2k8'; then
    echo 'jbarnett-r7/metasploitable3-win2k8 already found in Vagrant box repository. Skipping the addition to Vagrant.'
    echo "NOTE: If you are having issues, try starting over by doing 'vagrant destroy' and then 'vagrant up'."
else
    echo 'Attempting to add the box to Vagrant. This may take a while...'
    if vagrant box add jbarnett-r7/metasploitable3-win2k8; then
        echo "Box successfully added to Vagrant."
    else
        echo "Error adding box to Vagrant. See the above output for any error messages."
        exit 1
    fi
fi

echo "---------------------------------------------------------------------"
echo "SUCCESS: Run 'vagrant up' to provision and start metasploitable3."
echo "NOTE: The VM will need Internet access to provision properly."
