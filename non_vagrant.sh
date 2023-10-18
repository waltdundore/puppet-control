#!/bin/bash

ln -s . /vagrant
ln -s r10k/ /etc/puppetlabs/r10k/

exec ./r10k.sh
exec ./bootstrap.sh
