#!/bin/bash


cd ~
##################################
# puppet install and application #
##################################
wget http://apt.puppet.com/puppet7-release-bullseye.deb
dpkg -i ./puppet7-release-bullseye.deb
apt -y install puppet

/usr/bin/puppet module install puppetlabs-stdlib
/usr/bin/puppet module install puppet-selinux
/usr/bin/puppet module install saz-sudo
/usr/bin/puppet module install puppetlabs-docker

wget https://raw.githubusercontent.com/waltdundore/puppet-control/production/manifests/site.pp

/usr/bin/puppet apply site.pp


#git clone https://github.com/waltdundore/puppet-control.git
#cd puppet-control

###################
# Vagrant Install #
###################
apt -y install vagrant-libvirt libvirt-daemon-system
apt -y install vagrant ruby-libvirt \
qemu libvirt-daemon-system libvirt-clients ebtables \
dnsmasq-base libxslt-dev libxml2-dev libvirt-dev \
zlib1g-dev ruby-dev libguestfs-tools
systemctl start libvirtd
usermod --append --groups libvirt $USER

apt -y install meld terminator clementine gimp transmission-qt
cd ~ 
wget --content-disposition https://github.com/VSCodium/vscodium/releases/download/1.80.1.23194/codium_1.80.1.23194_amd64.deb
apt -y install ./codium*
wget --content-disposition https://mullvad.net/download/app/deb/latest
apt install -y ./Mullvad*
apt update -y
