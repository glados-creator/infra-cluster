set -x

# default
mkdir -p /mnt/bhole/volumes/colosseum/vicus-default/effbd7ff-fd15-4e5a-93a2-4be7039fb06b/technitium
mkdir -p /mnt/bhole/volumes/colosseum/vicus-default/effbd7ff-fd15-4e5a-93a2-4be7039fb06b/gatus
mkdir -p /mnt/bhole/volumes/colosseum/vicus-default/effbd7ff-fd15-4e5a-93a2-4be7039fb06b/dozzle
mkdir -p /mnt/bhole/volumes/colosseum/vicus-default/effbd7ff-fd15-4e5a-93a2-4be7039fb06b/authentik
mkdir -p /mnt/bhole/volumes/colosseum/vicus-default/effbd7ff-fd15-4e5a-93a2-4be7039fb06b/authentik/pgdata
mkdir -p /mnt/bhole/volumes/colosseum/vicus-default/effbd7ff-fd15-4e5a-93a2-4be7039fb06b/authentik/media/public
mkdir -p /mnt/bhole/volumes/colosseum/vicus-default/effbd7ff-fd15-4e5a-93a2-4be7039fb06b/netboot
mkdir -p /mnt/bhole/volumes/colosseum/vicus-default/effbd7ff-fd15-4e5a-93a2-4be7039fb06b/openwrt

mkdir -p /mnt/bhole/volumes/colosseum/vicus-default/effbd7ff-fd15-4e5a-93a2-4be7039fb06b/harbor
mkdir -p /mnt/bhole/volumes/colosseum/vicus-default/effbd7ff-fd15-4e5a-93a2-4be7039fb06b/harbor/core-data
mkdir -p /mnt/bhole/volumes/colosseum/vicus-default/effbd7ff-fd15-4e5a-93a2-4be7039fb06b/harbor/ca_download
mkdir -p /mnt/bhole/volumes/colosseum/vicus-default/effbd7ff-fd15-4e5a-93a2-4be7039fb06b/harbor/registry
mkdir -p /mnt/bhole/volumes/colosseum/vicus-default/effbd7ff-fd15-4e5a-93a2-4be7039fb06b/harbor/registry-root-crt
mkdir -p /mnt/bhole/volumes/colosseum/vicus-default/effbd7ff-fd15-4e5a-93a2-4be7039fb06b/harbor/job_logs
mkdir -p /mnt/bhole/volumes/colosseum/vicus-default/effbd7ff-fd15-4e5a-93a2-4be7039fb06b/harbor/trivy-adapter/trivy
mkdir -p /mnt/bhole/volumes/colosseum/vicus-default/effbd7ff-fd15-4e5a-93a2-4be7039fb06b/harbor/trivy-adapter/reports
mkdir -p /mnt/bhole/volumes/colosseum/vicus-default/effbd7ff-fd15-4e5a-93a2-4be7039fb06b/harbor/logs
mkdir -p /mnt/bhole/volumes/colosseum/vicus-default/effbd7ff-fd15-4e5a-93a2-4be7039fb06b/harbor/pgdata

# private
mkdir -p /mnt/bhole/volumes/colosseum/vicus-private/4a6c2f11-9025-429e-adc6-80f3f029c43e/gatus

mkdir -p /mnt/bhole/volumes/colosseum/vicus-private/4a6c2f11-9025-429e-adc6-80f3f029c43e/monitor/dozzle
mkdir -p /mnt/bhole/volumes/colosseum/vicus-private/4a6c2f11-9025-429e-adc6-80f3f029c43e/monitor/grafana
mkdir -p /mnt/bhole/volumes/colosseum/vicus-private/4a6c2f11-9025-429e-adc6-80f3f029c43e/monitor/grafana/plugins
mkdir -p /mnt/bhole/volumes/colosseum/vicus-private/4a6c2f11-9025-429e-adc6-80f3f029c43e/monitor/prometheus
mkdir -p /mnt/bhole/volumes/colosseum/vicus-private/4a6c2f11-9025-429e-adc6-80f3f029c43e/monitor/headlamp

mkdir -p /mnt/bhole/volumes/colosseum/vicus-private/4a6c2f11-9025-429e-adc6-80f3f029c43e/home/homeassistant/

mkdir -p /mnt/bhole/volumes/colosseum/vicus-private/4a6c2f11-9025-429e-adc6-80f3f029c43e/code/ollama
mkdir -p /mnt/bhole/volumes/colosseum/vicus-private/4a6c2f11-9025-429e-adc6-80f3f029c43e/code/vscodium
mkdir -p /mnt/bhole/volumes/colosseum/vicus-private/4a6c2f11-9025-429e-adc6-80f3f029c43e/code/n8n
mkdir -p /mnt/bhole/volumes/colosseum/vicus-private/4a6c2f11-9025-429e-adc6-80f3f029c43e/code/openclaw
mkdir -p /mnt/bhole/volumes/colosseum/vicus-private/4a6c2f11-9025-429e-adc6-80f3f029c43e/code/odysseus
mkdir -p /mnt/bhole/volumes/colosseum/vicus-private/4a6c2f11-9025-429e-adc6-80f3f029c43e/code/comfyui
mkdir -p /mnt/bhole/volumes/colosseum/vicus-private/4a6c2f11-9025-429e-adc6-80f3f029c43e/code/webui

# public
mkdir -p /mnt/bhole/volumes/colosseum/vicus-public/0213e1d8-87b6-43b0-a9be-d22436afb88a/gatus

# dmz
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/gatus

mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/frontalt/searxng/
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/frontalt/invidious/
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/frontalt/invidious/pgdata
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/frontalt/invidious/companion-cache
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/frontalt/piped/
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/frontalt/piped/pgdata

mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/cloud/immich/
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/cloud/immich/pgdata

mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/oss/forgejo/


mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/media
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/media/movies
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/media/tv
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/media/music
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/media/books
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/media/comics
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/media/videos
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/downloads
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/downloads/radarr
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/downloads/sonarr
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/downloads/lidarr
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/downloads/readarr
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/downloads/kapowarr
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/downloads/qbittorrent
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/downloads/unpackerr
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/jellyfin/config
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/jellyfin/cache
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/radarr/config
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/sonarr/config
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/lidarr/config
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/readarr/config
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/readarr/pgdata
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/kapowarr/db
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/prowlarr/config
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/jellyseerr/config
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/qbittorrent/config
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/tdarr/server
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/tdarr/configs
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/tdarr/logs
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/tdarr/temp
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/bazarr/config
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/autobrr/config
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/jellystat/data
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/jellystat/pgdata
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/unpackerr/config
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/profilarr/config
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/youtarr/config
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/youtarr/images
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/youtarr/jobs
mkdir -p /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/youtarr/mysql


# chown
# sudo chown -R 70:70 /mnt/bhole/volumes/colosseum/vicus-default/effbd7ff-fd15-4e5a-93a2-4be7039fb06b/authentik
# sudo chown -R 70:70 /mnt/bhole/volumes/colosseum/vicus-default/effbd7ff-fd15-4e5a-93a2-4be7039fb06b/harbor

# sudo chown -R 70:70 /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/frontalt/invidious/
# sudo chown -R 70:70 /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/frontalt/piped/

# sudo chown -R 70:70 /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/cloud/immich/

# sudo chown -R 70:70 /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/jellystat/
# sudo chown -R 70:70 /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/readarr/
# sudo chown -R 70:70 /mnt/bhole/volumes/colosseum/vicus-dmz/08622c4f-fd51-4c77-8d1c-9a5d3c6e6d66/media-stack/youtarr/

sudo chown -R 1000:1000 /mnt/bhole/volumes/colosseum/vicus-private/4a6c2f11-9025-429e-adc6-80f3f029c43e/monitor/grafana
sudo chown -R 65534:65534 /mnt/bhole/volumes/colosseum/vicus-private/4a6c2f11-9025-429e-adc6-80f3f029c43e/monitor/prometheus/
