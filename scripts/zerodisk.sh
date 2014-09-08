#!/bin/sh -eux

# Zero out the free space to save space in the final image
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
# Block until the empty file has been removed, otherwise, Packer
# will try to kill the box while the disk is still full and that's bad

# Sync to ensure that the delete completes before this moves on.
sync