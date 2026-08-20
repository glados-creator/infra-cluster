set -ex

rc-update add wpa_supplicant
rc-service wpa_supplicant start

echo """
auto lo
iface lo inet loopback
iface lo inet6 loopback

# Ethernet
auto eth0
iface eth0 inet static
    address 192.168.1.24/24
    gateway 192.168.1.254

    # Secondary address
    up ip addr add 172.16.0.24/24 dev eth0

# Wi-Fi
auto wlan0
iface wlan0 inet static
    wpa-roam .etc/wpa_supplicant.conf
    address 192.168.1.25/24

    # Secondary address
    up ip addr add 172.16.0.25/24 dev wlan0

    # Backup default route via Wi-Fi
    up ip route add default via 192.168.1.254 dev wlan0 metric 200 || true
"""


rc-service networking restart

# update dns else everything fire with 1970 clock
echo "nameserver 1.1.1.1" >> /etc/resolvconf.conf