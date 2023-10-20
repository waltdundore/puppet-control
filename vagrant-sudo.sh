#!/bin/bash

cat << EOF >> /etc/sudoers.d/10-vagrant-sudo
Defaults:vagrant !requiretty
vagrant ALL=(ALL) NOPASSWD: ALL
EOF
