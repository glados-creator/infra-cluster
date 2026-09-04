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
apk add qemu

apk add nfs-utils

# install and cp multus ... cni thingy
apk add cni-plugins
sudo cp /usr/libexec/cni/* /opt/cni/bin/
sudo chmod +x /opt/cni/bin/*

sudo mkdir -p /bhole
rc-update add netmount
nano /etc/fstab
# add shared,lazytime to / too
echo "none /run tmpfs defaults,shared,lazytime 0 0" >> /etc/fstab
echo "none /sys sysfs defaults,shared,lazytime 0 0" >> /etc/fstab
echo "none /sys/fs/cgroup cgroup2 defaults,lazytime 0 0" >> /etc/fstab
echo "192.168.1.24:/bhole /bhole nfs defaults,_netdev,lazytime 0 0" >> /etc/fstab
# mount -t nfs 192.168.1.24:/bhole /bhole

nano /etc/rc.conf
# rc_cgroup_mode="unified"
# rc_ulimit="-n 65535"
echo 'rc_cgroup_mode="unified"' | sudo tee -a /etc/rc.conf
echo 'rc_ulimit="-n 65535"' | sudo tee -a /etc/rc.conf
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
  --kubelet-arg=--fail-swap-on=false \
  --kube-proxy-arg=--proxy-mode=nftables" bash

curl -sfL https://get.k3s.io | sh -s - server \
  --token XXX \
  --server https://192.168.1.14:6443 \
  --disable=traefik \
  --disable=helm-controller \
  --flannel-backend=none \
  --disable-network-policy \
  --disable=servicelb \
  --disable=metrics-server \
  --node-label=server=true \
  --kubelet-arg=--fail-swap-on=false \
  --kube-proxy-arg=--proxy-mode=nftables
  # --cluster-init \
  # --node-name=k3sm \


# echo '''
# {
#   "capabilities": {
#     "portMappings": true
#   },
#   "cniVersion": "0.3.1",
#   "logLevel": "verbose",
#   "logToStderr": true,
#   "name": "multus-cni-network",
#   "clusterNetwork": "/host/etc/cni/net.d/10-calico.conflist",
#   "type": "multus-shim"
# }
# ''' > /etc/cni/net.d/00-multus.conf

echo '''
mirrors:
  docker.io:
    endpoint:
      - "http://harbor.main.home/docker"
  ghcr.io:
    endpoint:
      - "http://harbor.main.home/ghcr"
  quay.io:
    endpoint:
      - "http://harbor.main.home/quay"
  codeberg.org:
    endpoint:
      - "http://harbor.main.home/codeberg"
  lscr.io:
    endpoint:
      - "http://harbor.main.home/lscr"
configs:
  "harbor.main.home":
    auth:
      username: <CHANGEME>
      password: <CHANGEME>
    tls:
      insecure_skip_verify: true
''' > /etc/rancher/k3s/registries.yaml

sysctl -w fs.inotify.max_user_watches=524288
sysctl -w fs.file-max=65535
echo "fs.inotify.max_user_watches=524288" > /etc/sysctl.d/00-limits.conf
echo "fs.file-max=65535" | tee -a /etc/sysctl.d/00-limits.conf
