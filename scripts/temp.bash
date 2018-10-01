#!/bin/bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

UBUNTU_CODENAME=$(lsb_release -s -c)	#Xenial bionic
UBUNTU_VERSION=$(lsb_release -rs)	#16.04 18.04

MYHOME="/home/${SUDO_USER}"

# APP LIST
APP_LIST=(
    arp-scan # local network scan
    build-essential
    cifs-utils
    clang clang-format
    cmake
    cmus # A Console Based Audio Player for Linux
    cron
    curl
    # dkms
    espeak
    exfat-fuse exfat-utils
    expect
    g++ gcc
    gimp
    git
    gparted
    gpsprune
    gzip
    handbrake-gtk handbrake-cli
    htop
    imagemagick
    inkscape
    keepass2
    netcat
    nmap
    npm
    ntp
    openssh-client openssh-server
    openvpn
    packeth
    pavucontrol
    pdfshuffler
    pinta
    python-pip
    python3-pip
    screen
    # shutter
    simplescreenrecorder simplescreenrecorder-lib
    sqlite3
    ssh
    sshfs
    steam
    synaptic
    syncthing
    tcpdump
    telnet
    texlive-full texstudio
    tree
    tmux
    ubuntu-restricted-extras
    vim
    virtualbox
    vlc
    wireshark
    xclip
    youtube-dl
)

OPTS=`getopt -o cnth --long config,new-install,test,help -n 'parse-options' -- "$@"`

usage() { echo "Error - Usage: $0 [-c || --config] [-n || --new-install] [-t || --test] [-h || --help]" 1>&2; exit 1; }


if [ $? != 0 ] ; then echo "Failed parsing options." usage >&2 ; exit 1 ; fi

echo "$OPTS"
eval set -- "$OPTS"

while true; do
  case "$1" in
    -c | --config )         CONFIG=true;        shift ;;
    -n | --new-install )    NEW_INSTALL=true;   shift ;;
    -t | --test )           TEST=true;          shift ;;
    -h | --help )           HELP=true;          shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

# echo "CONFIG = ${CONFIG}"
# echo "NEW_INSTALL = ${NEW_INSTALL}"
# echo "TEST = ${TEST}"
# echo "HELP = ${HELP}"

# Update the system
apt_update()
{
    echo "Update list of available packages"
    apt update
}

bionic_install()
{
    if [ ! -z "${NEW_INSTALL}" ]; then
        echo "Initializing a fresh install" 
        remove_stuff
        add_ppa
        install_app
        # install_gchrome
        install_spotify
        install_docker
        # install_minecraft
        install_kicad
    fi

    if [ ! -z "${CONFIG}" ]; then
        wireshark_config
        git_config
        vim_config
        tmux_config
    fi

    if [ ! -z "${TEST}" ]; then
        echo "Initializing test" 
        install_docker
    fi
}

remove_stuff()
{
    # Remove unused folders
    echo "Removing unwanted directories"
    rm -rf $MYHOME/Templates
    rm -rf $MYHOME/Examples
}

add_ppa()
{
    echo "Adding PPAs"

    sudo add-apt-repository "deb http://archive.canonical.com/ubuntu $(lsb_release -sc) partner"

    # open source video transcoder
    sudo add-apt-repository ppa:stebbins/handbrake-releases -y

    # shutter
    # sudo add-apt-repository ppa:shutter/ppa

    # Syncthing
    curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
    echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list


    # SimpleScreenRecorder : https://launchpad.net/~maarten-baert/+archive/ubuntu/simplescreenrecorder
    sudo add-apt-repository ppa:maarten-baert/simplescreenrecorder -y

    echo "Updating package lists ..."
    sudo apt update -qq

}

install_app()
{
    echo "Installing apps now ..."
    sudo apt -y install "${APP_LIST[@]}"
}

install_gchrome()
{
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
    sudo apt-get update
    sudo apt-get install google-chrome-stable -y
}

install_spotify()
{
    # Add the Spotify repository signing keys to be able to verify downloaded packages
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90

    # Add the Spotify repository
    echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
    
    # update package listing
    sudo apt update

    # Install Spotify
    sudo apt -y install spotify-client
}

install_minecraft()
{
    # minecraft
    sudo add-apt-repository -y ppa:minecraft-installer-peeps/minecraft-installer
    # update package listing
    sudo apt update
    sudo apt -y install minecraft-installer
}

install_kicad()
{
    # kicad pcb design http://kicad-pcb.org/download/ubuntu/
    sudo add-apt-repository --yes ppa:js-reynaud/kicad-4
    # update package listing
    sudo apt update
    sudo apt -y install kicad
}

install_docker()
{
    # Uninstall old versions
    sudo apt-get remove docker docker-engine docker.io

    # Install using the repository
    sudo apt update

    # Install packages to allow apt to use a repository over HTTPS:
    sudo apt -y install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common

    # Add Docker’s official GPG key:
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    # verify fingerprint
    sudo apt-key fingerprint 0EBFCD88

    # set up the stable repository
    sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

    # INSTALL DOCKER CE
    sudo apt update
    sudo apt -y install docker-ce
    # sudo apt-get install docker-ce=<VERSION>

    # add current user to docker group
    sudo usermod -aG docker $SUDO_USER

    # test docker ce is installed correctly 
    sudo docker run hello-world
}

wireshark_config()
{
    echo "Give user privelages for wireshark"
    sudo dpkg-reconfigure wireshark-common
    echo "a wireshark group been created in /etc/gshadow. so add user to it"
    sudo gpasswd -a $SUDO_USER wireshark
}

git_config() {
    sudo -u ${SUDO_USER} git config --global user.name "Waleed Khan"
    sudo -u ${SUDO_USER} git config --global user.email "wqkhan@uwaterloo.ca"
    #git config --global push.default matching
}

vim_config()
{
    BUNDLE="$MYHOME/.vim/bundle"
    if [ ! -d "$BUNDLE/Vundle.vim" ]; then
        sudo -u ${SUDO_USER} mkdir -p "$BUNDLE"
        sudo -u ${SUDO_USER} git clone https://github.com/VundleVim/Vundle.vim.git "$BUNDLE/Vundle.vim"
    fi

    # Update existing (or new) installation
    cd "$BUNDLE/Vundle.vim"
    sudo -u ${SUDO_USER} git pull -q
    # In order to update Vundle.vim and all your plugins directly from the command line you can use a command like this:
    sudo -u ${SUDO_USER} vim -c VundleInstall -c quitall

    echo "Vim setup updated."

    if [ -f $MYHOME"/.vimrc" ] ; then
        rm $MYHOME"/.vimrc"
    fi
    sudo -u ${SUDO_USER} cp $REPO_DIR"/config/vim/vimrc" $MYHOME"/.vimrc"
}

tmux_config()
{

    if [ -f $MYHOME"/.tmux.conf" ] ; then
        rm $MYHOME"/.tmux.conf"
    fi
    sudo -u ${SUDO_USER} cp $REPO_DIR"/config/tmux/tmux.conf" $MYHOME"/.tmux.conf"
}

main()
{
    echo "System is running: ${UBUNTU_CODENAME} ${UBUNTU_VERSION}"

    # -z string True if the string is null (an empty string)
    if [ ! -z "${HELP}" ]; then
        echo "Requesting help: "
        usage
    fi

    apt_update
    clear

    case $UBUNTU_CODENAME in
        trusty)
            main_14 ;;
        xenial)
            (main_16 "$@") ;;
        bionic)
            bionic_install ;;
        *)
            echo "Unsupported version of Ubuntu detected. Only bionic (18.04.*) are currently supported."
            exit 1 ;;
    esac
}

main