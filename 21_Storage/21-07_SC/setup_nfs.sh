#!/usr/bin/bash

# Variables
NFS_SHARE="/var/nfs-share

# Main
echo "Install NFS Package"
sudo dnf update  >/dev/null
sudo dnf install -y nfs-utils

echo "Create NFS Share"
sudo mkdir /nfs-share
sudo chmod -R 777 $NFS_SHARE 
#sudo chown nobody:nogroup $NFS_SHARE
echo "/nfs-share  ol-node-02(rw)" | sudo tee -a /etc/exports > /dev/null

echo "Set Firewall Rules"
sudo firewall-cmd --permanent --zone=public --add-service=nfs
sudo firewall-cmd --reload
sudo firewall-cmd --list-all

echo "Start NFS"
sudo systemctl enable --now nfs-server

echo "Test NFS"
showmount -e
mkdir ~/nfs-mount
mount edu-worker:/var/share ~/nfs-mount
echo "Test NFS" >> ~/nfs-mount/test.txt

sudo ls $NFS_SHARE
