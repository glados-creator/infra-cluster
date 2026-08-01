# sudo route add -net 172.16.0.0 netmask 255.255.255.0 gw 192.168.1.252 metric 2
# alpine v3.22 for CONFIG_IP_NF_* 
set -ex

apk update
apk upgrade
apk add tree
# apk add qemu-guest-agent
# rc-update add qemu-guest-agent 
# rc-service qemu-guest-agent start 
# apk add pciutils usbutils
apk add nano git curl bash sudo util-linux e2fsprogs e2fsprogs-extra 
apk add iproute2 cgroup-tools shadow-uidmap 
apk add iptables ip6tables 
apk add nftables 
apk add ca-certificates 
# apk add lm-sensors zram-init 
# apk add htop btop fish zsh
# apk add etcd-ctl

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
# echo " cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory cgroup_enable=freezer cgroup_enable=hugetlb swapaccount=1 systemd.unified_cgroup_hierarchy=1" >> /boot/cmdline.txt
sync
reboot
# mount | grep cgroup

curl https://get.k3s.io | INSTALL_K3S_EXEC="server \
  --cluster-init \
  --disable=traefik \
  --disable=helm-controller \
  --flannel-backend=none \
  --disable-network-policy \
  --disable=servicelb \
  --node-name=k3sm \
  --node-label=server=true \
  --kubelet-arg=--fail-swap-on=false" bash

curl -sfL https://get.k3s.io | sh -s - server \
  --token K10cXXX::server:XXX \
  --cluster-init \
  --disable=traefik \
  --disable=helm-controller \
  --flannel-backend=none \
  --disable-network-policy \
  --disable=servicelb \
  --disable=metrics-server \
  --node-label=server=true \
  --kubelet-arg=--fail-swap-on=false
  # --node-name=k3sm \
