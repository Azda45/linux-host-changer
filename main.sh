#!/bin/bash

# Pastikan script dijalankan sebagai root
if [[ $EUID -ne 0 ]]; then
   echo "Script ini harus dijalankan sebagai root" 
   exit 1
fi

# Ambil hostname baru dari argumen atau minta input
if [ -z "$1" ]; then
    read -p "Masukkan hostname baru: " NEW_HOSTNAME
else
    NEW_HOSTNAME="$1"
fi

# Validasi hostname
if [[ ! "$NEW_HOSTNAME" =~ ^[a-zA-Z0-9.-]+$ ]]; then
    echo "Hostname tidak valid. Gunakan huruf, angka, titik, atau tanda hubung."
    exit 1
fi

# Ubah hostname secara langsung
hostnamectl set-hostname "$NEW_HOSTNAME"

# Perbarui file /etc/hostname
echo "$NEW_HOSTNAME" > /etc/hostname

# Perbarui file /etc/hosts
sed -i "s/^127.0.1.1\s.*/127.0.1.1 $NEW_HOSTNAME/" /etc/hosts

# Konfirmasi perubahan
echo "Hostname berhasil diubah menjadi: $NEW_HOSTNAME"

# Restart service hostname tanpa reboot
systemctl restart systemd-logind

exit 0
