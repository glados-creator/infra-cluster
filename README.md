# infra-cluster
## here is my k8s k3s cluster

### computers
- rpi5-a/b
- rpi4-a/b
- rpi3-a/b
- rpi3-a/b
- rpi02W-a/b

- big astra
- medium jupiter
- stitan

rpi 2 rpi 1 rpi0W-a/b armV7 too old 32bits so no images for them

### storage
- rpi5-a/b (temp nfs)
- big astra (ceph todo)
- medium jupiter (ceph todo)
- stitan (ceph todo)

### CRD Custome Ressources Definition
- [X] calico CNI (network)
- [~] mutlus CNI plugin (network)(have multiple interfaces)
- [~] MetalLB (LoadBalancer)
- [~] traefik CRD reverse proxy
- [~] metric server (kubectl top api crd for dozzle)
- [~] vulcano (gang scheduler gpus)
- [~] keda (trigger action on event)
- [~] spinkube (launch wasm/wasi pod)
- [~] kubevirt (proxmox but docker)
- [~] rook (ceph PV provider)
- [ ] ? velero ? (PV backup) (but maybe i can with ceph)
- [~] linkerd (mtls mesh)
- [~] Generic Device Plugin (usb passtrough)
- [ ] prometheuse node exporter (metrics) / kube-state-metrics (KSM)
- [X] nvidia runtime 
  ```bash
  # to apply the controller label if it's not done automaticly
  kubectl label node <node-name> nixos-nvidia-cdi=enabled --overwrite
  ```

## zones

1. built-in
    + core DNS
    + traeffik ingress controller
    + metric server
    + local-path PV
    + (kube kustomize)
    + (the CRDs)
2. default/main
    + technitium DNS (use tmp kube-proxy for install)
    + traefik reverse proxy via ingress-route controller
    + glance (app dir)
    + gatus (monitoring uptime)
    + dozzle (logging)
    + authentik (auth)
    + Harbor (Docker registry, multi)
3. public
    + glance (app dir)
    + gatus (monitoring uptime)
4. dmz/demilitarized/priviled
    + glance (app dir)
    + gatus (monitoring uptime)
    + media
        + Jellyfin
        + Radarr
        + Sonarr
        + Lidarr
        + Readarr
        + Kapowarr
        + Prowlarr
        + Jellyseerr
        + qBittorrent
        + Tdarr
        + Bazarr
        + Autobrr
        + Jellystat
        + Unpackerr
        + Profilarr
        + YouTarr
        + SuggestArr TODO
5. private
    + glance (app dir)
    + gatus (monitoring uptime)
    + home
        + home-assistant
    + monitoring  
        + dozzle (logging)
        + grafana
        + prometheus
        + headlamp
        + ... TODO
    + code
        + ollama (LLM)
        + webui
        + comfyui
        + n8n (automation, multi)
        + odysseus (AI chat)
        + vscodium-server (with podman-in-docker TODO) + opencode (code assistant TODO)
        + openclaw (AI agent)

**modes**
- production
- dev
```bash
kubectl apply -f overlay/production
```

=============================
todos : 
- [ ] finish CRDs
    - [ ] tls auth certificate certificate issuer kittizz.github.io/cert-manager-technitium-webhook/
    - [ ] generic-device-plugin
    - [ ] kubevirt
    - [ ] spinkube
    - [ ] rook
- [ ] default
    - [ ] openwrt router
    - [ ] gluetun (VPN, single)
    - [ ] honeypot (decoy, single)
    - [ ] redirect

- [ ] public
    - [ ] personal-site (blog)
    - [ ] wordpress (CMS, multi)
    - [ ] url shortener (url shortener) ?
    - [ ] redirect

- [ ] dmz
    - [ ] Mailu (email server, multi)
    - [ ] cloud/
        - [ ] Immich (photos, multi)
        - [ ] OpenCloud (file sync, multi)
        - [ ] Paperless (docs, multi)
    - [ ] oss/
        - [ ] ? telnet demo (telnet demo) ?
        - [ ] Forgejo (Git hosting, multi)
        - [ ] ? Forgejo push action runner (...) ?
    - [ ] game/ (*.gg)
        - [ ] ? Pterodactyl (game server panel, multi) / modrinth ?
        - [ ] dolphin-games (emulator, single)
        - [ ] halfix (VM/emulator, single)
    - [ ] alternative-frontends/ (*.alt)
        - [ ] matrix + element X https://matrix.org/ecosystem/clients/
        - [ ] ? navidrom / my own / Hyperpipe / BeatBump (ytb music alt) ?    
        - [ ] SearXNG / Websurfx / LibreX (search, multi)
        - [ ] Invidious / Piped / Viewtube (YouTube alt, multi)
        - [ ] Libreddit / Redlib (Reddit alt, multi)
        - [ ] ? AnonymousOverflow (StackOverflow alt, multi) ?
    - [ ] redirect

- [ ] private
    - [ ] home/
        - [ ] OctoPrint (3D print, single)
        - [ ] Excalidraw (drawing, multi)
        - [ ] Kiwix (offline Wikipedia, single)
        - [ ] steam-gaming (headless, multi)
    - [ ] feed/
        - [ ] ntfy (push, multi)
        - [ ] mollysocket (Signal bridge, multi)
        - [ ] RSSHub + Miniflux (RSS, multi/single)
    - [ ] tools/
        - [ ] netboot-main (PXE, TBD)
        - [ ] headscale (Tailscale alt, multi)
        - [ ] squid (forward proxy, multi)    
        - [ ] ? Guacamole (remote gateway, multi) / webtop ?
        - [ ] RustDesk (remote desktop, multi)
        - [ ] ? Ente Auth (multi TBD) ?
        - [ ] ? password-manager (e.g., Vaultwarden, multi) ?
    - [ ] monitoring/
        - [ ] loki
        - [ ] elastic-beats
        - [ ] logstash
        - [ ] elasticsearch
        - [ ] kibana
        - [ ] ? datadog ?
    - [ ] code/
        - [ ] exo AI daemonset ? 
        - [ ] hermes AI like webui ?
        - [ ] webtop (tmp linux vm)
        - [ ] podman in docker VScodium
        - [ ] opencode
    - [ ] redirect

general TODOS
- [x] TODO finish doc
- [ ] repair pod / upgrade pod
    - [ ] add authentik
    - [ ] n8n N8N_SECURE_COOKIE=false
    - [ ] webui permissions
    - [ ] HA reverse proxy
    - [ ] headlamp still trying to get .kube
    - [ ] jellystat bad gateway ? maybe wrong url ?
    - [ ] prometheuse scrape gatus maybe wrong urls ?
    - [ ] radarr can't set perms
    - [ ] sonarr can't set perms
    - [ ] qbittorrent can't login
    - [ ] readarr bad gateway
    - [ ] tdarr bad gateway
    - [ ] unpackerr bad gateway
    - [ ] webui gateway timeout

    - [ ]  odysseus
    - [ ]  comfyui
    - [ ]  openclaw
    - [ ] gatus home assistant + notif push
- [ ] do soci imagesf
- [ ] do ceph / rock operator
- [ ] add peripherals
- [ ] move GH repos to codeforge

upgrade paths

TODO : kustomize patch ingress urls for dev env
TODO : containerdev / devpod & CI
TODO : soci image
[soci image](https://github.com/awslabs/soci-snapshotter)

ip2n the tor thingy / tor
for alt see https://github.com/digitalblossom/alternative-frontends
idk https://github.com/stackryze/FreeDomains
free domaine https://github.com/DigitalPlatDev/FreeDomain
jellyfin stack https://github.com/Wh1rr/ultimate-jellyfin-stack
nvidia in nixos https://github.com/OlfillasOdikno/generic-cdi-plugin
docker up to date https://github.com/getwud/wud
stack https://github.com/silveiralexf/monitoring-stack
this https://github.com/priyazsh/DevProfiles
alt list https://github.com/awesome-selfhosted/awesome-selfhosted

### peripherals
/// rpi 2 4k tv

### ansible
building the cluster with ansible
OSes:
- astra / jupiter / stitan nixos see [my NixOs config](https://github.com/glados-creator/nixos)
- rasberry pis rpis -> alpine linux , so openrc and ansible

```bash
nix-shell -p ansible
fish
ansible-playbook -v -i k3s-inventory.ini 01-bootstrap.yml
ansible-playbook -v -i k3s-inventory.ini 02-install-basic.yml
ansible-playbook -v -i k3s-inventory.ini 03-install-server.yml
ansible-playbook -v -i k3s-inventory.ini 03-join-additional-servers.yml
ansible-playbook -v -i k3s-inventory.ini 03-join-workers.yml
ansible-playbook -v -i k3s-inventory.ini 04-uninstall-k3s.yml
```

```env
[all:vars]
ansible_user=<Account-Name> # {{ inventory_hostname }}
ansible_ssh_pass=<Account-Password>
ansible_become_pass=<Root-Password>
ansible_become_method=su
ansible_python_interpreter=/usr/bin/python3
ansible_connection=ssh
ansible_ssh_common_args='-o StrictHostKeyChecking=no'

# --- server nodes (k0s controller rootless)
[k3s_servers]
rpi5a

# --- worker nodes (external ectd)
[k3s_workers]
rpi5b
```

1. prepare a node to install python , apk update ect
2. install the basics like iptables nano curl ect and set up the pis kernel parameters
3. install the first server
4. put the calico CRD
5. install additional servers if HA shared etcd or postgresSQL server see [k3s datastore](https://docs.k3s.io/datastore)
6. install additional workers
7. script to uninstall

... please copy all of the .example files and put in the fields

TEMP script to install nfs share for PV
installing Ceph for storage nodes TODO



===============
OLD
- [~] headscale (tailscale alt)
- [~] immich (image)
- [~] mollysocket signal notif push
- [~] ntfy push notif
- [~] opencloud (nextcloud in go)
- [~] rsshub + miniflux (rss news)
- [~] searxng / Websurfx / LibreX ? (google alt)
- [~] an honeypot (secure)
- [~] sourceforge / forgejo (git)
- [~] Invidious ?? Piped / Viewtube ?? (ytb frontend)
- [~] octoprint (3D print)
- [~] Kiwix (download wikipedia)
- [~] navidrom / my own / Hyperpipe / BeatBump (ytb music alt)
- [~] Libreddit / redlib (reddit alt)
- [~] AnonymousOverflow (StackOverflow alt)
- [X] Bibliogram [Deprecated] (Instagram)
- [~] matrix + element X https://matrix.org/ecosystem/clients/
- [~] url shortener
- [~] rustdesk
- [~] guacamole
- [~] Pterodactyl https://github.com/pterodactyl/application-eggs
- [~] docker repo / harbor
- [~] vscodium online server + pdoman in docker + devpod + IA opencodex
- [~] password manager
- [~]  ente
- [~] wordpress
- [~] personal site
- [~] monitoring loki Elasticsearch Logstash:  Kibana:  Beats:  
- [~] mailu
- [~] paperless ?
- [~] n8n ?
- [~] github action 
- [~] excalidraw
- [~] ssh / telnet server animation
- [X] Duck cmd helper / copy party -> opencloud
- [~] halfix https://github.com/NSG650/halfix
- [~] jarvis home assitant
- [~] dolphin games
- [~] squid forward proxy
- [~] add steam gaming headless server
- [ ] let's encrypt ?