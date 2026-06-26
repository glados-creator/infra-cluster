# system
# main
glance IP 2200
gatus IP 2201
dozzle IP 2215
traefik LB static ip 192.168.1.1 LB 80 443 IP 2280 2282
technitium LB static ip 192.168.1.2 LB 53 853 443 80 8053 IP 2283 2284
(kubectl port-forward --address 0.0.0.0 svc/technitium-service 2283:2283)
authentik IP 2288 2289
glueton TBD
redirect IP 2202 TODO

# public
glance IP 9900
gatus IP 9901
redirect IP 9902 TODO

# dmz
glance IP 6600
gatus IP 6601
redirect IP 6602 TODO

### dmz/media
┌─────────────────┬─────────┬───────┬─────────────────────────────────────────────────┐
│ Service         │ Port    │ svc   │ Purpose                                         │
├─────────────────┼─────────┼───────┼─────────────────────────────────────────────────┤
│ Jellyfin        │ 8096/8920/7359   │ 6650/6651/6653  │ Media server (streaming)     │
│ Radarr          │ 7878    │ 6654  │ Movie management                                │
│ Sonarr          │ 8989    │ 6655  │ TV show management                              │
│ Lidarr          │ 8686    │ 6656  │ Music management                                │
│ Readarr         │ 8787    │ 6657  │ Book / audiobook management                     │
│ Kapowarr        │ 5656    │ 6658  │ Comic management                                │
│ Prowlarr        │ 9696    │ 6659  │ Indexer manager for *arr apps                   │
│ Jellyseerr      │ 5055    │ 6660  │ Request management & discovery                  │
│ qBittorrent     │ 8080/6881 │ 6661/6662    │ BitTorrent client (Web UI) (VPNed gluetun hide.me)            │
│ Tdarr           │ 8265    │ 6663  │ Media transcoding / optimisation                │
│ Bazarr          │ 6767    │ 6664  │ Subtitle management                             │
│ Autobrr         │ 7474    │ 6665  │ IRC / announce bot for instant grabs            │
│ Jellystat       │ 3001    │ 6666  │ Jellyfin usage statistics                       │
│ Unpackerr       │ 5656    │ 6667  │ Archive extraction (starts at 5656)             │
│ Profilarr       │ 6868    │ 6668  │ Radarr/Sonarr profile & custom format sync      │
│ YouTarr         │ 3087    │ 6669  │ YouTube playlist monitor (Radarr‑like)          │
└─────────────────┴─────────┴─────────────────────────────────────────────────────────┘

# private
glance IP 4400 TODO CONF
gatus IP 4401 TODO CONF
redirect IP 4402 TODO
dozzle IP 4415

### private/code
webui 4425
ollama 4426
vscodium 
vscoduim-pind 
openclaw 