# sudo route add -net 172.16.0.0 netmask 255.255.255.0 gw 192.168.1.252 metric 2
set -ex

apk update
apk upgrade
apk add qemu-guest-agent fish zsh
apk add pciutils usbutils nano git curl bash sudo util-linux e2fsprogs e2fsprogs-extra iptables ip6tables nftables ca-certificates lm-sensors zram-init iproute2 cgroup-tools shadow-uidmap htop btop
apk add nfs-utils

sudo mkdir -p /bhole
rc-update add netmount
echo "none /run tmpfs defaults,shared 0 0" >> /etc/fstab
echo "none /sys sysfs defaults,shared 0 0" >> /etc/fstab
echo "none /sys/fs/cgroup cgroup2 defaults 0 0" >> /etc/fstab
echo "192.168.1.24:/bhole /bhole nfs defaults,_netdev,lazytime 0 0" >> /etc/fstab
# mount -t nfs 192.168.1.24:/bhole /bhole

nano /etc/rc.conf
# rc_cgroup_mode="unified"
rc-update add cgroups
rc-service cgroups start
sync
reboot
# mount | grep cgroup

curl https://get.k3s.io | INSTALL_K3S_EXEC="server --cluster-init --disable=traefik --disable=helm-controller --flannel-backend=none --disable-network-policy --disable=servicelb --node-name=k3sm --node-label=server=true" bash
