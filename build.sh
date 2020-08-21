#!/bin/bash

min_vbox_ver="5.1.10"
min_vagrant_ver="1.9.0"
min_packer_ver="0.10.0"
min_vagrantreload_ver="0.0.1"
min_vagrantvmware_ver="0.0.1"
min_vagrantlibvirt_ver="0.0.1"
packer_bin="packer"
packer_build_path="packer/builds"

case "$1" in
    ubuntu1404)  echo "building ubuntu 1404"
                 os_full="ubuntu_1404"
                 os_short="ub1404"
                 ;;

    windows2008) echo "building windows 2008"
                 os_full="windows_2008_r2"
                 os_short="win2k8"
                 ;;

    *)           echo "Invalid OS. Valid options are 'ubuntu1404' and 'windows2008'"
                 exit 1
                 ;;
esac

box_version=$(grep \"box_version\": packer/templates/$os_full.json | grep -Eow "[0-9]\.[0-9]\.[0-9]+")

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
    if (cat /etc/*-release | grep -q 'DISTRIB_ID=Arch')|(cat /etc/os-release | grep -Pq 'ID=(arch|"antergos")'); then
        packer_bin="packer-io"
    fi
fi

providers=""

if [ -x "$(which VBoxManage)" ] ; then
    current_vbox_ver=$(VBoxManage -v | sed -e 's/r.*//g' -e 's/_.*//g')
    if compare_versions $current_vbox_ver $min_vbox_ver false; then
        echo "Compatible version of VirtualBox found."
        echo "Virtualbox images will be built."
        providers="virtualbox $providers"
    else
        echo "Compatible version of VirtualBox was not found."
        echo "Current Version=[$current_vbox_ver], Minimum Version=[$min_vbox_ver]"
        echo "Please download and install it from https://www.virtualbox.org/"
        echo "Virtualbox images will not be built."
    fi
else
    echo "VirtualBox is not installed (or not added to the path)."
    echo "Please download and install it from https://www.virtualbox.org/"
    echo "Virtualbox images will not be built."
fi

if compare_versions $($packer_bin -v) $min_packer_ver false; then
    echo "Compatible version of $packer_bin was found."
else
    packer_bin=packer
    if compare_versions $($packer_bin -v) $min_packer_ver false; then
        echo "Compatible version of $packer_bin was found."
    else
        echo "Compatible version of packer was not found. Please install from here: https://www.packer.io/downloads.html"
        exit 1
    fi
fi

if compare_versions $(vagrant -v | cut -d' ' -f2) $min_vagrant_ver $vagrant_exact_match; then
    echo 'Correct version of vagrant was found.'
else
    echo "Compatible version of vagrant was not found. Please download and install it from https://www.vagrantup.com/downloads.html."
    exit 1
fi

if [ $(uname) = "Linux" ]; then
  if compare_versions $(vagrant plugin list | grep 'vagrant-libvirt' | cut -d' ' -f2 | tr -d '(' | tr -d ')' | tr -d ',') $min_vagrantlibvirt_ver false; then
      echo 'Compatible version of vagrant-libvirt plugin was found.'
      echo 'KVM image will be built.'
      providers="qemu $providers"
      echo 'Fetching virtio drivers required for build'
      ./packer/scripts/virtio-win-drivers.sh
  else
      echo "Compatible version of vagrant-libvirt plugin was not found."
  fi
fi

if compare_versions $(vagrant plugin list | grep 'vagrant-vmware' | cut -d' ' -f2 | tr -d '(' | tr -d ')' | tr -d ',') $min_vagrantvmware_ver false; then
  echo 'Compatible version of vagrant-vmware plugin was found.'
  echo 'VMware image will be built'
  providers="vmware $providers"
fi

if compare_versions $(vagrant plugin list | grep 'vagrant-reload' | cut -d' ' -f2 | tr -d '(' | tr -d ')' | tr -d ',') $min_vagrantreload_ver false; then
    echo 'Compatible version of vagrant-reload plugin was found.'
else
    echo "Compatible version of vagrant-reload plugin was not found."
    echo "Attempting to install..."
    if vagrant plugin install vagrant-reload; then
        echo "Successfully installed the vagrant-reload plugin."
    else
        echo "There was an error installing the vagrant-reload plugin. Please see the above output for more information."
        exit 1
    fi
fi

if [ "$providers" == "" ]; then
    echo "No virtual machine providers found, aborting"
    exit 1
fi

echo "Requirements found. Proceeding..."

for provider in $providers; do
    search_string="$os_full"_"$provider"_"$box_version"
    mkdir -p "$packer_build_path"
    if [ -e $packer_build_path/$search_string.box ]; then
      echo "It looks like the $provider vagrant box already exists. Skipping the build."
    else
      echo "Building the Vagrant box for $provider..."
      packer_provider="$provider-iso"
      if [ $provider = "qemu" ]; then
        packer_provider=$provider
      fi
      if $packer_bin build -only $packer_provider packer/templates/$os_full.json; then
          echo "Boxes successfully built by Packer."
      else
          echo "Error building the Vagrant boxes using Packer. Please check the output above for any error messages."
          exit 1
      fi
    fi
done

echo "Attempting to add the box to Vagrant..."

for provider in $providers; do
    if vagrant box list | grep -q rapid7/metasploitable3-"$os_short"; then
        echo "rapid7/metasploitable3-$os_short already found in Vagrant box repository. Skipping the addition to Vagrant."
        echo "NOTE: If you are having issues, try starting over by doing 'vagrant destroy' and then 'vagrant up'."
    else
        if [ -z $box_import ]; then
            if [ $provider = "qemu" ]; then
              provider="libvirt"
            fi
            if vagrant box add $packer_build_path/"$os_full"_"$provider"_"$box_version".box --name rapid7/metasploitable3-$os_short; then
            echo "Box successfully added to Vagrant."
            else
            echo "Error adding box to Vagrant. See the above output for any error messages."
            fi
        else
            echo "No builders produced a working box."
            echo "Check you have build dependencies installed."
            echo "Useful diagnostic information could be above. Aborting!"
        fi
    fi
done

echo "---------------------------------------------------------------------"
echo "SUCCESS: Run 'vagrant up' to provision and start metasploitable3."
echo "NOTE: The VM will need Internet access to provision properly."
