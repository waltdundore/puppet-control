#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

if [ ! -f .env ]
then
  export $(cat .env | xargs)
fi

#fix ssh auth
if grep -wq "env_keep+=SSH_AUTH_SOCK" /etc/sudoers;
then
  echo "No changes made, /etc/sudoers already updated" 
else    
  echo "Defaults    env_keep+=SSH_AUTH_SOCK" >> /etc/sudoers && \
  systemctl restart sshd
fi


if [ -d "/root/.ssh" ]  
then 
  echo "No changes made, /root/.ssh already exists"
else 
  echo "Creating that directory now..."
  mkdir -p /root/.ssh/
fi

chmod 0600 /root/.ssh/*
 
#dnf -y install ruby


/opt/puppetlabs/bin/puppet module install puppetlabs-stdlib --version 9.3.0
/opt/puppetlabs/bin/puppet module install puppet-selinux --version 4.0.0
/opt/puppetlabs/bin/puppet module install saz-sudo --version 8.0.0
/opt/puppetlabs/bin/puppet module install puppetlabs-docker --version 9.1.0
/opt/puppetlabs/bin/puppet module install puppet-epel --version 5.0.0


/usr/local/bin/r10k deploy environment production -pv && /opt/puppetlabs/bin/puppet apply --environment production /etc/puppetlabs/code/environments/production/manifests/site.pp

