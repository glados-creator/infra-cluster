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

- rpi 2 rpi 1 rpi0W-a/b armV7 too old 32bits so no images for them

### storage
- rpi5-a/b (temp nfs)
- big astra (ceph todo)
- medium jupiter (ceph todo)
- stitan (ceph todo)

### CRD Custome Ressources Definition
- [X] traefik CRD controller (builtin)
- [X] calico CNI (network)(TODO)
- [X] nvidia runtime 
  ```bash
  # to apply the controller label if it's not done automaticly
  kubectl label node <node-name> nixos-nvidia-cdi=enabled --overwrite
  ```
- [X] vulcano (gang scheduler gpus)
- [X] metric server (kubectl top api crd for dozzle)
- [X] keda (trigger action on event)
- [] kubevirt (proxmox but docker)
- [] prometheus CRD (monitoring)
- [] rook (ceph PV provider)
- [] ? velero ? (PV backup) (but maybe i can with ceph)

## zones

1. built-in
    + core DNS
    + traeffik ingress controller
    + metric server
    + local-path PV
    + (TEMP) flannel CNI
    + (kube kustomize)
    + (the CRDs)
2. default/main
    + technitium DNS
    + traefik reverse proxy via ingress-route controller
    + a dozzle (logging)
3. public
4. dmz/demilitarized/priviled
5. private

ip2n the tor thingy / tor

**modes**
- production
- dev
```bash
kubectl apply -f overlay/production
```

TODO : kustomize patch ingress urls for dev env
TODO : containerdev / devpod & CI

for alt see https://github.com/digitalblossom/alternative-frontends
idk https://github.com/stackryze/FreeDomains
free domaine https://github.com/DigitalPlatDev/FreeDomain
jellyfin stack https://github.com/Wh1rr/ultimate-jellyfin-stack
nvidia in nixos https://github.com/OlfillasOdikno/generic-cdi-plugin
docker up to date https://github.com/getwud/wud
stack https://github.com/silveiralexf/monitoring-stack
this https://github.com/priyazsh/DevProfiles
alt list https://github.com/awesome-selfhosted/awesome-selfhosted
todos : 
- [ ] TODO do doc
- [ ] add pod
    - [ ] graphana (monitoring)
    - [ ] prometheus (monitoring)
    - [ ] headscale (tailscale alt)
    - [ ] immich (image)
    - [ ] mollysocket signal notif push
    - [ ] ntfy push notif
    - [ ] opencloud (nextcloud in go)
    - [ ] rsshub + miniflux (rss news)
    - [ ] searxng / Websurfx / LibreX ? (google alt)
    - [ ] an honeypot (secure)
    - [ ] sourceforge / forgejo (git)
    - [ ] Invidious ?? Piped / Viewtube ?? (ytb frontend)
    - [ ] octoprint (3D print)
    - [ ] Kiwix (download wikipedia)
    - [ ] navidrom / my own / Hyperpipe / BeatBump (ytb music alt)
    - [ ] Libreddit / redlib (reddit alt)
    - [ ] AnonymousOverflow (StackOverflow alt)
    - [ ] Bibliogram [Deprecated] (Instagram)
    - [ ] matrix + element X https://matrix.org/ecosystem/clients/
    - [ ] url shortener
    - [ ] gluetun (VPN)
    - [ ] rustdesk
    - [ ] guacamole
    - [ ] open code + open claw / tiny claw + autogpt ?
    - [ ] Pterodactyl https://github.com/pterodactyl/application-eggs
    - [ ] docker repo / harbor
    - [ ] vscodium online server + pdoman in docker + devpod + IA opencodex
    - [ ] password manager
    - [ ]  ente
    - [ ] wordpress
    - [ ] personal site
    - [ ] Elasticsearch Logstash:  Kibana:  Beats:  
    - [ ] authentik ?
    - [ ] mailu
    - [ ] traefik dmz private auth plugin
    - [ ] paperless ?
    - [ ] n8n ?
    - [ ] github action 
    - [ ] excalidraw
    - [ ] ssh / telnet server animation
    - [ ] Duck cmd helper
    - [ ] halfix https://github.com/NSG650/halfix
    - [ ] netboot
    - [ ] jarvis home assitant
    - [ ] dolphin games
    - [ ] squid forward proxy
    - [ ] let's encrypt ?
- [ ] repair pod
    - [ ] gatus home assistant notif push
- [ ] do calico CNI
- [ ] do ceph / rock operator
- [ ] add peripherals
- [ ] move GH repos to codeforge

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