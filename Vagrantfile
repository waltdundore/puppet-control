# -*- mode: ruby -*-
# vi: set ft=ruby :

# Load settings
require 'yaml'
settings_path = '.vagrant.yml'
settings = {}

if File.exist?(settings_path)
  settings = YAML.load_file(settings_path)
end

# Overrides and defaults
VAGRANT_CPUS       = settings['VAGRANT_CPUS']       || 4
VAGRANT_MEMORY     = settings['VAGRANT_MEMORY']     || 8192
VAGRANT_BOX        = settings['VAGRANT_BOX']        || 'generic/rocky9'
VAGRANT_HOSTNAME   = settings['VAGRANT_HOSTNAME']   || 'nuc.dundore.net'
VAGRANT_SSHFORWARD = settings['VAGRANT_SSHFORWARD'] || 'false'
VAGRANT_DBDL       = settings['VAGRANT_DBDL']       || 'false'

Vagrant.configure(2) do |config|

  config.vm.box = VAGRANT_BOX
  config.vm.hostname = VAGRANT_HOSTNAME
  config.vm.network :private_network, type: 'dhcp'
  config.ssh.forward_agent = VAGRANT_SSHFORWARD

  config.vm.provider :libvirt do |libvirt|
    libvirt.cpus = VAGRANT_CPUS
    libvirt.memory = VAGRANT_MEMORY
  end

  config.vm.provision "shell", inline: "cat << EOF >> /etc/sudoers.d/10_tmp_vagrant
    Defaults:vagrant !requiretty
    vagrant ALL=(ALL) NOPASSWD: ALL
    EOF"

  #add swap partition
    config.vm.provision "shell", path: "addswap.sh"


    config.vm.synced_folder ".", "/vagrant",
        type: "nfs",
        nfs_version: 4,
        nfs_udp: false

    config.vm.synced_folder "r10k/", "/etc/puppetlabs/r10k/",
        type: "nfs",
        nfs_version: 4,
        nfs_udp: false

# Provisioning scripts
    config.vm.provision "shell", path: "r10k.sh"
    config.vm.provision "shell", path: "bootstrap.sh"

end
