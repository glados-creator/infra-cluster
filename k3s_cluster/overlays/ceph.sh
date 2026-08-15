set -x

# default
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-default/daeef6bb-d993-4383-86af-2745a851bf55/technitium
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-default/daeef6bb-d993-4383-86af-2745a851bf55/gatus
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-default/daeef6bb-d993-4383-86af-2745a851bf55/dozzle
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-default/daeef6bb-d993-4383-86af-2745a851bf55/authentik
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-default/daeef6bb-d993-4383-86af-2745a851bf55/authentik/pgdata
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-default/daeef6bb-d993-4383-86af-2745a851bf55/authentik/media/public
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-default/daeef6bb-d993-4383-86af-2745a851bf55/netboot
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-default/daeef6bb-d993-4383-86af-2745a851bf55/openwrt

mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-default/daeef6bb-d993-4383-86af-2745a851bf55/harbor
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-default/daeef6bb-d993-4383-86af-2745a851bf55/harbor/core-data
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-default/daeef6bb-d993-4383-86af-2745a851bf55/harbor/ca_download
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-default/daeef6bb-d993-4383-86af-2745a851bf55/harbor/registry
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-default/daeef6bb-d993-4383-86af-2745a851bf55/harbor/registry-root-crt
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-default/daeef6bb-d993-4383-86af-2745a851bf55/harbor/job_logs
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-default/daeef6bb-d993-4383-86af-2745a851bf55/harbor/trivy-adapter/trivy
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-default/daeef6bb-d993-4383-86af-2745a851bf55/harbor/trivy-adapter/reports
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-default/daeef6bb-d993-4383-86af-2745a851bf55/harbor/logs
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-default/daeef6bb-d993-4383-86af-2745a851bf55/harbor/pgdata

# private
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-private/c8e734df-e422-4b77-8ab5-ef8ece645e26/gatus

mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-private/c8e734df-e422-4b77-8ab5-ef8ece645e26/monitor/dozzle
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-private/c8e734df-e422-4b77-8ab5-ef8ece645e26/monitor/grafana
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-private/c8e734df-e422-4b77-8ab5-ef8ece645e26/monitor/grafana/plugins
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-private/c8e734df-e422-4b77-8ab5-ef8ece645e26/monitor/prometheus
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-private/c8e734df-e422-4b77-8ab5-ef8ece645e26/monitor/headlamp

mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-private/c8e734df-e422-4b77-8ab5-ef8ece645e26/home/homeassistant/

mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-private/c8e734df-e422-4b77-8ab5-ef8ece645e26/code/ollama
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-private/c8e734df-e422-4b77-8ab5-ef8ece645e26/code/vscodium
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-private/c8e734df-e422-4b77-8ab5-ef8ece645e26/code/n8n
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-private/c8e734df-e422-4b77-8ab5-ef8ece645e26/code/openclaw
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-private/c8e734df-e422-4b77-8ab5-ef8ece645e26/code/odysseus
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-private/c8e734df-e422-4b77-8ab5-ef8ece645e26/code/comfyui
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-private/c8e734df-e422-4b77-8ab5-ef8ece645e26/code/webui

# public
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-public/30251adb-9178-40ba-81b3-465cdc0f5ea6/gatus

# dmz
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/gatus

mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/frontalt/searxng/
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/frontalt/invidious/
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/frontalt/invidious/pgdata
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/frontalt/invidious/companion-cache
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/frontalt/piped/
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/frontalt/piped/pgdata

mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/cloud/immich/
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/cloud/immich/pgdata

mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/oss/forgejo/


mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/media
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/media/movies
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/media/tv
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/media/music
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/media/books
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/media/comics
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/media/videos
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/downloads
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/downloads/radarr
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/downloads/sonarr
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/downloads/lidarr
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/downloads/readarr
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/downloads/kapowarr
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/downloads/qbittorrent
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/downloads/unpackerr
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/jellyfin/config
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/jellyfin/cache
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/radarr/config
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/sonarr/config
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/lidarr/config
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/readarr/config
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/readarr/pgdata
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/kapowarr/db
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/prowlarr/config
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/jellyseerr/config
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/qbittorrent/config
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/tdarr/server
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/tdarr/configs
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/tdarr/logs
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/tdarr/temp
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/bazarr/config
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/autobrr/config
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/jellystat/data
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/jellystat/pgdata
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/unpackerr/config
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/profilarr/config
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/youtarr/config
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/youtarr/images
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/youtarr/jobs
mkdir -p /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/youtarr/mysql


# chown
# sudo chown -R 70:70 /mnt/bhole/volumes/k8s-colosseum/vicus-default/daeef6bb-d993-4383-86af-2745a851bf55/authentik
# sudo chown -R 70:70 /mnt/bhole/volumes/k8s-colosseum/vicus-default/daeef6bb-d993-4383-86af-2745a851bf55/harbor

# sudo chown -R 70:70 /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/frontalt/invidious/
# sudo chown -R 70:70 /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/frontalt/piped/

# sudo chown -R 70:70 /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/cloud/immich/

# sudo chown -R 70:70 /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/jellystat/
# sudo chown -R 70:70 /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/readarr/
# sudo chown -R 70:70 /mnt/bhole/volumes/k8s-colosseum/vicus-dmz/8496c355-8ebf-4b44-836e-3bbbf7c1d88d/media-stack/youtarr/

sudo chown -R 1000:1000 /mnt/bhole/volumes/k8s-colosseum/vicus-private/c8e734df-e422-4b77-8ab5-ef8ece645e26/monitor/grafana
sudo chown -R 65534:65534 /mnt/bhole/volumes/k8s-colosseum/vicus-private/c8e734df-e422-4b77-8ab5-ef8ece645e26/monitor/prometheus/
