apk update && apk upgrade
echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
apk add tailscale tailscale-openrc
rc-update add tailscale default
rc-service tailscale start
tailscale up