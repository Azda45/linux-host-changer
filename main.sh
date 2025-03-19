#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

if [ -z "$1" ]; then
    read -p "Enter a new hostname: " NEW_HOSTNAME
else
    NEW_HOSTNAME="$1"
fi

if [[ ! "$NEW_HOSTNAME" =~ ^[a-zA-Z0-9.-]+$ ]]; then
    echo "Invalid hostname. Use letters, numbers, periods, or hyphens."
    exit 1
fi

hostnamectl set-hostname "$NEW_HOSTNAME"

echo "$NEW_HOSTNAME" > /etc/hostname

sed -i "s/^127.0.1.1\s.*/127.0.1.1 $NEW_HOSTNAME/" /etc/hosts

echo "Hostname successfully changed to: $NEW_HOSTNAME"

systemctl restart systemd-logind

exit 0
