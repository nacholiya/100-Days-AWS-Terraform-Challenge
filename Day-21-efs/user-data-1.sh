#!/bin/bash
apt update -y
apt install -y nfs-common

mkdir -p /mnt/efs

mount -t nfs4 ${efs_dns}:/ /mnt/efs

echo "${efs_dns}:/ /mnt/efs nfs4 defaults,_netdev 0 0" >> /etc/fstab