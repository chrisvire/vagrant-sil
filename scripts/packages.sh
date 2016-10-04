#!/usr/bin/env bash
# Need to be run with sudo

# add PSO
wget -qO - http://packages.sil.org/sil.gpg | apt-key add -
add-apt-repository "deb http://packages.sil.org/ubuntu $(lsb_release -sc) main"
add-apt-repository "deb http://packages.sil.org/ubuntu $(lsb_release -sc)-experimental main"
apt-get update

apt-get install -y curl aptitude synaptic gdebi
apt-get install -y vim git git-gui gitk ssh
apt-get install -y meld kdiff3-qt terminator unity-tweak-tool

# Automate Accepting EULA
# http://askubuntu.com/a/25614/24712
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
apt-get install -y ttf-mscorefonts-installer

apt-get remove -y deja-dup
