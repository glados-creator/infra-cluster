apk update && apk upgrade
apk add tailscale tailscale-openrc
rc-update add tailscale default
rc-service tailscale start
tailscale up