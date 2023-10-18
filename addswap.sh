#!/bin/bash

SWAPFILE='/swap'
SWAPSIZE_MB='1024'

if grep -q "${SWAPFILE}\b" /proc/swaps; then
  echo 'swap exists, skipping addswap'
  exit 0
fi

dd if=/dev/zero of="${SWAPFILE}" bs=1M count="${SWAPSIZE_MB}"

mkswap "${SWAPFILE}"

chmod 0600 "${SWAPFILE}"

swapon "${SWAPFILE}"