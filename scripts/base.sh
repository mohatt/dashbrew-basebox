#!/bin/bash -eux

# ppa for apache 2.4.10
add-apt-repository -y ppa:ondrej/apache2

# ppa for latest php 5.5
add-apt-repository -y ppa:ondrej/php5

# ppa for mysql 5.5.39
add-apt-repository -y ppa:ondrej/mysql-5.5

# ppa for latest node.js
add-apt-repository -y ppa:chris-lea/node.js

# Update the package list
apt-get update

# Upgrade all installed packages incl. kernel and kernel headers
apt-get -y upgrade linux-server linux-headers-server

# ensure the correct kernel headers are installed
apt-get -y install linux-headers-$(uname -r)

# sshd tweak to prevent DNS resolution
echo "UseDNS no" >> /etc/ssh/sshd_config
echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config

# sudo
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers
sed -i -e 's/%sudo\s*ALL=(ALL:ALL) ALL/%sudo\tALL=NOPASSWD:ALL/g' /etc/sudoers

# Remove 5s grub timeout to speed up booting
cat <<EOF > /etc/default/grub
# If you change this file, run 'update-grub' afterwards to update
# /boot/grub/grub.cfg.

GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_CMDLINE_LINUX="debian-installer=en_US"
EOF

update-grub