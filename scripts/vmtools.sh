#!/bin/bash

case "$PACKER_BUILDER_TYPE" in

virtualbox-iso|virtualbox-ovf)
    mkdir /tmp/vbox
    VER=$(cat /home/$PACKER_SSH_USERNAME/.vbox_version)
    mount -o loop /home/$PACKER_SSH_USERNAME/VBoxGuestAdditions_$VER.iso /tmp/vbox
    sh /tmp/vbox/VBoxLinuxAdditions.run
    umount /tmp/vbox
    rmdir /tmp/vbox
    rm /home/$PACKER_SSH_USERNAME/*.iso
    ;;

vmware-iso|vmware-vmx) 
    mkdir /tmp/vmfusion
    mkdir /tmp/vmfusion-archive
    mount -o loop /home/$PACKER_SSH_USERNAME/linux.iso /tmp/vmfusion
    tar xzf /tmp/vmfusion/VMwareTools-*.tar.gz -C /tmp/vmfusion-archive
    /tmp/vmfusion-archive/vmware-tools-distrib/vmware-install.pl --default
    umount /tmp/vmfusion
    rm -rf  /tmp/vmfusion
    rm -rf  /tmp/vmfusion-archive
    rm /home/$PACKER_SSH_USERNAME/*.iso
    ;;

*)
    echo "Unknown Packer Builder Type >>$PACKER_BUILDER_TYPE<< selected."
    echo "Known are virtualbox-iso|virtualbox-ovf|vmware-iso|vmware-ovf."
    ;;

esac