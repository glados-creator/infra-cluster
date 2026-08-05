wget https://downloads.openwrt.org/releases/24.10.8/targets/bcm27xx/bcm2711/openwrt-24.10.8-bcm27xx-bcm2711-rpi-4-ext4-factory.img.gz
gunzip openwrt-24.10.8-bcm27xx-bcm2711-rpi-4-ext4-factory.img.gz
# Install libguestfs-tools if not present
sudo apk add libguestfs-tools

# Extract the entire root filesystem from the image to a directory
mkdir openwrt-root/
virt-copy-out -a openwrt-24.10.8-bcm27xx-bcm2711-rpi-4-ext4-factory.img / openwrt-root/

# Create a tarball of the extracted rootfs
tar -C openwrt-root -czf openwrt-rootfs.tar.gz .

# Import the tarball into Podman
podman import openwrt-rootfs.tar.gz my-openwrt:arm64

# Save the image as an OCI tarball
podman save my-openwrt:arm64 -o my-openwrt.tar

# Import into containerd
sudo ctr image import my-openwrt.tar