#!/bin/bash

# Install r10k
setenforce 0
dnf -y remove ruby
dnf -y module reset ruby
dnf -y module enable ruby:2.7
dnf -y install ruby ruby-devel
dnf -y install git
gem install multipart-post -v 2.3.0
gem install semantic_puppet -v 1.1.0

dnf -y install git

dnf -y install wget curl nano



echo ########################################################
echo #                 installing puppet agent              #
echo ########################################################

#install puppet-agent
cd /tmp
wget -q https://yum.puppetlabs.com/puppet/el/9/x86_64/puppet-agent-7.26.0-1.el9.x86_64.rpm -O puppet-agent.rpm
rpm -Uvh /tmp/puppet-agent.rpm

#without this r10k fails to install
dnf -y install redhat-rpm-config
gem install r10k -v 4.0.0

# r10k not in path by default
if ! grep -q "export PATH=" /root/.bashrc; then
  echo "export PATH=\$PATH:/usr/local/bin" >> /root/.bashrc
fi
