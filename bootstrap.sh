#/bin/bash

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


cat << EOF >> /etc/sudoers.d/vagrant-syncedfolders
Cmnd_Alias VAGRANT_EXPORTS_CHOWN = /bin/chown 0\:0 /tmp/vagrant-exports
Cmnd_Alias VAGRANT_EXPORTS_MV = /bin/mv -f /tmp/vagrant-exports /etc/exports
Cmnd_Alias VAGRANT_NFSD_CHECK = /usr/bin/systemctl status --no-pager nfs-server.service
Cmnd_Alias VAGRANT_NFSD_START = /usr/bin/systemctl start nfs-server.service
Cmnd_Alias VAGRANT_NFSD_APPLY = /usr/sbin/exportfs -ar
%vagrant ALL=(root) NOPASSWD: VAGRANT_EXPORTS_CHOWN, VAGRANT_EXPORTS_MV, VAGRANT_NFSD_CHECK, VAGRANT_NFSD_START, VAGRANT_NFSD_APPL
EOF




/opt/puppetlabs/bin/puppet module install puppetlabs-stdlib --version 9.3.0
/opt/puppetlabs/bin/puppet module install puppet-selinux --version 4.0.0
/opt/puppetlabs/bin/puppet module install saz-sudo --version 8.0.0
/opt/puppetlabs/bin/puppet module install puppetlabs-docker --version 9.1.0
/opt/puppetlabs/bin/puppet module install puppet-epel --version 5.0.0
/opt/puppetlabs/bin/puppet module install puppetlabs-vcsrepo --version 6.1.0
/opt/puppetlabs/bin/puppet module install puppetlabs-sshkeys_core --version 2.4.0
/opt/puppetlabs/bin/puppet module install puppet-archive --version 7.0.0

ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

/usr/local/bin/r10k deploy environment production -pv && /opt/puppetlabs/bin/puppet apply --environment production /etc/puppetlabs/code/environments/production/manifests/site.pp

