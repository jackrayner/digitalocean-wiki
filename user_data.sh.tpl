#!/bin/sh

# Mount the volume
mkdir -p ${volume_mountpoint}
mount -o discard,defaults /dev/disk/by-label/${volume_name} ${volume_mountpoint}
echo /dev/disk/by-label/${volume_name} ${volume_mountpoint} ext4 defaults,nofail,discard 0 0 | sudo tee -a /etc/fstab


#fallocate -l 2G /swapfile
#chmod 0600 /swapfile
#mkswap /swapfile
#swapon /swapfile
apt-get update
apt-get install --assume-yes \
    vim \
    git \
    curl \
    wget
