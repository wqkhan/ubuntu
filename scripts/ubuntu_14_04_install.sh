#!/bin/bash

<<<<<<< HEAD
echo "Adding PPAs"
add-apt-repository ppa:gnome-terminator -y
add-apt-repository ppa:eugenesan/ppa -y
apt-add-repository ppa:blahota/texstudio -y
sudo add-apt-repository ppa:diesch/testing
=======
set -e
>>>>>>> a33671e79347e80b8bfc97238a3e39b618766182

add_ppa()
{
	echo "Adding PPAs"
	add-apt-repository ppa:gnome-terminator -y
	add-apt-repository ppa:eugenesan/ppa -y
	apt-add-repository ppa:blahota/texstudio -y
}

<<<<<<< HEAD
echo "Installing packages"
apt-get install build-essential ubuntu-restricted-extras synaptic alacarte classicmenu-indicator exfat-fuse exfat-utils gcc g++ openssh-server openssh-client git xclip terminator texlive-full mc texstudio vlc -y 
=======
apt_update()
{
	echo "updating repositories"
	apt-get update
}

install_packages()
{
	echo "Installing packages"
	apt-get install build-dep build-essential ubuntu-restricted-extras synaptic exfat-fuse exfat-utils gcc g++ openssh-server openssh-client git xclip terminator texlive-full mc texstudio vlc vim wireshark libnss3* -y 
}

#add_ppa
apt_update
install_packages
>>>>>>> a33671e79347e80b8bfc97238a3e39b618766182

echo "Finished adding PPAs and insatlling applications"
exit 0

