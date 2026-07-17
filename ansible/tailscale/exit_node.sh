apk update
apk upgrade
apk add tailscale iptables ip6tables
apk add nano
nano /etc/sysctl.conf
# net.ipv4.ip_forward = 1
# net.ipv6.conf.all.forwarding = 1
sysctl -p /etc/sysctl.conf
tailscale up --advertise-exit-node --advertise-routes=192.168.1.0/24,172.16.0.0/24
rc-update add tailscale default
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
