#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

apt-get update
apt-get install i2c-tools -y

# Disable the first i2c interface
raspi-config nonint do_i2c 0

# Set i2c interface to 400Khz. The pi is dumb and requires a higher
# requested speed than what is actually set.
echo "options i2c_bcm2708 baudrate=600000" >> /etc/modprobe.d/i2c.conf