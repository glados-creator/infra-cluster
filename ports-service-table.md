# main (22xx)
glance             2200
gatus              2201
dozzle             2215
OPNsense LB static ip 172.16.0.1 192.168.1.252 XXX TBD IP 2240 2243
traefik LB static ip 172.16.0.2/192.168.1.2 LB 80 443 IP 2280 2282
technitium LB static ip 172.16.0.3/192.168.1.3 LB 53 853 443 80 8053 IP 2283 2284
(kubectl port-forward --address 0.0.0.0 svc/main-technitium-service 2283:2283)
authentik          2288 2289 (/if/flow/initial-setup/ password URL)
glueton            TBD
redirect           2202 TODO
harbor             IP 2290 2291 2292 2293 2294

# public (99xx)
glance             9900
gatus              9901
redirect           9902 TODO
wordpress          9904

# dmz (66xx)
glance             6600
gatus              6601
redirect           6602 TODO

### dmz/cloud
Immich             6604
OpenCloud          6605
Paperless          6606

### dmz/oss
Forgejo            6608
Harbor             6609

### dmz/game
Pterodactyl        6610
dolphin-games      6611
halfix             6612

### dmz/alternative-frontends
matrix-element     6613
SearXNG            6614
Invidious-Piped    6615
Libreddit-Redlib   6616

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
│ SuggestArr      │ 5000    │ 6670  │ Media Automation & AI-Powered Recommendations   │ 
│ YouTarr         │ 3087    │ 6669  │ YouTube playlist monitor (Radarr‑like)          │
└─────────────────┴─────────┴─────────────────────────────────────────────────────────┘

# private (44xx)
glance             4400
gatus              4401
redirect           4402 TODO

### private/home
OctoPrint          4403
home-assistant     4404
Excalidraw         4405
Kiwix              4406
steam-gaming       4407

### private/feed
ntfy               4408
mollysocket        4409
RSSHub             4410
Miniflux           4411

### private/tools
headscale          4412
squid              4413
netboot-playzone   4414
RustDesk           4417
Ente-Auth          4418
Vaultwarden        4419

### private/monitoring
headlamp           4420
grafana            4421
prometheus         4422
loki               4423
elasticsearch      4424
logstash           4427
kibana             4428

### private/code
n8n                4429
odysseus           4430
ollama             4431
openclaw           4432
vscodium           4433
webui              4434
comfyui            4435