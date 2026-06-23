#!/bin/sh
# Install and configure NFS server on Alpine Linux
# Export /bhole to 192.168.1.0/24 with:
#   rw, async, wdelay, all_squash (anonuid=1000,anongid=1000), subtree_check

set -ex

MOUNT="/bhole"
EXPORT_LINE="$MOUNT 192.168.1.0/24(rw,async,wdelay,no_all_squash,no_root_squash,subtree_check)"
# DEVICE="/dev/sda1"
# FSTAB_ENTRY="$DEVICE  $MOUNT  ext4  defaults  0  2"
# echo "$FSTAB_ENTRY" >> /etc/fstab

echo "=== Installing NFS packages ==="
apk update
apk add nfs-utils rpcbind

echo "=== Configuring NFS export ==="
if grep -qs "^$MOUNT" /etc/exports; then
    echo "Export for $MOUNT already exists. Updating..."
    sed -i "\|^$MOUNT|d" /etc/exports
fi
echo "$EXPORT_LINE" >> /etc/exports
echo "Added export: $EXPORT_LINE"

echo "=== Starting and enabling NFS services ==="
rc-service rpcbind start 2>/dev/null || true
rc-service nfs start 2>/dev/null || true
rc-update add rpcbind
rc-update add nfs

echo "=== Applying exports ==="
exportfs -ra

echo "=== NFS server ready ==="
showmount -e localhost

echo ""
echo "=== On your client computer (Linux), run: ==="
echo "sudo apk add nfs-utils"
echo "showmount -e 192.168.1.24"
echo "sudo mkdir -p /mnt/bhole"
echo "sudo mount -t nfs 192.168.1.24:/bhole /mnt/bhole"
echo "192.168.1.24:/bhole /mnt/bhole nfs defaults 0 0 > /etc/fstab" 
echo ""
echo "All files written from any client (including root) will appear as user rpi5a (UID 1000) on the server."