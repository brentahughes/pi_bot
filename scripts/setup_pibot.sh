#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

cat >> /etc/systemd/system/pibot.service <<EOL
[Unit]
Description=Automatically starts pibot on system boot
After=multi-user.target
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/home/pi/pibot/pi_bot
[Install]
WantedBy=multi-user.target
EOL

systemctl enable autohotspot.service