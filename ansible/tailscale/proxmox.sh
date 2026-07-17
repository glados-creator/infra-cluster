nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_idle.max_cstate=1 pcie_aspm=off"

nano /etc/network/interfaces
auto eno1
iface eno1 inet static
    post-up ethtool -G eno1 rx 4096 tx 4096