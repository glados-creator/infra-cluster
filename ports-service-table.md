# Main Services (22xx)

| Service    | LoadBalancer IP(s)                     | Port(s)           |
| ------------| ----------------------------------------| -------------------|
| glance     | None                                   | 2200              |
| gatus      | None                                   | 2201              |
| redirect   | None                                   | 2202 (TODO)       |
| netboot    | 172.16.0.9 : 69                        | 2203 2204         |
| gluetun    | None                                   | 2205 (TODO)       |
| honeypot   | None                                   | 2206 (TODO)       |
| linkerd    | None                                   | 2207 (TODO)       |
| dozzle     | None                                   | 2215              |
| openwrt    | 172.16.0.1, 172.16.99.1, 192.168.1.252 | 2240, 2243 (TODO) |
| traefik    | 172.16.0.2 : 80, 443                   | 2280, 2282        |
| technitium | 172.16.0.3 : 53, 853                   | 2283, 2284        |
| authentik  | None                                   | 2288, 2289        |
| harbor     | None                                   | 2290-2294         |
(kubectl port-forward --address 0.0.0.0 svc/main-technitium-service 2283:2283)

---

# Public Services (99xx)

| Service       | Port(s)     |
| ---------------| -------------|
| glance        | 9900        |
| gatus         | 9901        |
| redirect      | 9902 (TODO) |
| personal-site | 9903 (TODO) |
| wordpress     | 9904 (TODO) |
| url-shortener | 9905 (TODO) |

---

# DMZ Services (66xx)

#### General
| Service  | Port(s)     |
| ----------| -------------|
| glance   | 6600        |
| gatus    | 6601        |
| redirect | 6602 (TODO) |
| Mailu    | 6603 (TODO) |

#### Cloud
| Service   | Port(s)     |
| -----------| -------------|
| Immich    | 6604 (TODO) |
| OpenCloud | 6605 (TODO) |
| Paperless | 6606 (TODO) |

#### OSS
| Service | Port(s)     |
| ---------| -------------|
| Forgejo | 6608 (TODO) |

#### Game
| Service       | Port(s)     |
| ---------------| -------------|
| Pterodactyl   | 6610 (TODO) |
| dolphin-games | 6611 (TODO) |
| halfix        | 6612 (TODO) |

#### Alternative Frontends (*.alt)
| Service            | Port(s)        |
| --------------------| ----------------|
| Matrix + Element X | 6613 (TODO)    |
| SearXNG            | 6614           |
| Invidious          | 6615           |
| Piped              | 6616 6617 6618 |
| Libreddit / Redlib | 6619 (TODO)    |

#### Media
| Service     | Port(s)          |
| -------------| ------------------|
| Jellyfin    | 6650, 6651, 6653 |
| Radarr      | 6654             |
| Sonarr      | 6655             |
| Lidarr      | 6656             |
| Readarr     | 6657             |
| Kapowarr    | 6658             |
| Prowlarr    | 6659             |
| Jellyseerr  | 6660             |
| qBittorrent | 6661, 6662       |
| Tdarr       | 6663             |
| Bazarr      | 6664             |
| Autobrr     | 6665             |
| Jellystat   | 6666             |
| Unpackerr   | 6667             |
| Profilarr   | 6668             |
| YouTarr     | 6669             |
| SuggestArr  | 6670 (TODO)      |

---

# Private Services (44xx)

| Service  | Port(s)     |
| ----------| -------------|
| glance   | 4400        |
| gatus    | 4401        |
| redirect | 4402 (TODO) |

#### Home
| Service        | Port(s)     |
| ----------------| -------------|
| OctoPrint      | 4403 (TODO) |
| home-assistant | 4404        |
| Excalidraw     | 4405 (TODO) |
| Kiwix          | 4406 (TODO) |
| steam-gaming   | 4407 (TODO) |

#### Feed
| Service     | Port(s)     |
| -------------| -------------|
| ntfy        | 4408 (TODO) |
| mollysocket | 4409 (TODO) |
| RSSHub      | 4410 (TODO) |
| Miniflux    | 4411 (TODO) |

#### Tools
| Service     | Port(s)     |
| -------------| -------------|
| headscale   | 4412 (TODO) |
| squid       | 4413 (TODO) |
| Guacamole   | 4414 (TODO) |
| webtop      | 4415 (TODO) |
| RustDesk    | 4416 (TODO) |
| Ente-Auth   | 4417 (TODO) |
| Vaultwarden | 4418 (TODO) |

#### Monitor
| Service       | Port(s)     |
| ---------------| -------------|
| headlamp      | 4420        |
| grafana       | 4421        |
| prometheus    | 4422        |
| loki          | 4423 (TODO) |
| elasticsearch | 4424 (TODO) |
| elastic-beats | 4425 (TODO) |
| datadog       | 4426 (TODO) |
| logstash      | 4427 (TODO) |
| kibana        | 4428 (TODO) |

#### Code
| Service  | Port(s)     |
| ----------| -------------|
| n8n      | 4429        |
| odysseus | 4430        |
| ollama   | 4431        |
| openclaw | 4432        |
| vscodium | 4433        |
| webui    | 4434        |
| comfyui  | 4435        |
| exo AI   | 4436 (TODO) |
| hermes   | 4437 (TODO) |
| opencode | 4438 (TODO) |
