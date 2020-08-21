#!/usr/bin/env bash

# URI for downloading the latest WHQL'd Virtio drivers
virtio_release="virtio-win-0.1.117_amd64"
virtio_release_folder="virtio-win-0.1.117-1"
virtio_uri="https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/${virtio_release_folder}/${virtio_release}.vfd"

# le flag
have_tools=true

# Tools messages
need_wget () {
    echo "Could not find wget, which is needed to download the virtio disk."
    echo "To install -"
    echo ""
    echo "Fedora: sudo dnf install wget"
    echo "Debian/Ubuntu: sudo apt install wget"
}

need_7z () {
    echo "Could not find 7z, which is required for extracting the virtio driver disk."
    echo "To install -"
    echo ""
    echo "Fedora: sudo dnf install p7zip p7zip-plugins"
    echo "Debian/Ubuntu: sudo apt install p7zip-full"
}

# Check for needed tools
if [ ! -x /usr/bin/wget ]; then
    need_wget
    have_tools=false
fi

if [ ! -x /usr/bin/7z ]; then
    need_7z
    have_tools=false
fi

if [ "$have_tools" = true ]; then
    if [ -f ".${virtio_release}.vfd" ]; then
	echo ".${virtio_release}.vfd already exists, skipping download."
    else
	echo "Downloading and extracting virtio ${virtio_release} drivers."
	wget -c "${virtio_uri}" -O ".${virtio_release}.vfd" && 7z x -oresources/drivers/virtio/"${virtio_release}" ".${virtio_release}.vfd" amd64/Win2008R2
    fi
fi
