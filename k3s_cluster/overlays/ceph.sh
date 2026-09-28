set -x

# Get the mons + key from Rook
# kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- ceph mon dump
# kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- ceph auth get-key client.admin
# 
# sudo mkdir -p /mnt/bhole
# echo "<admin-key>" | sudo tee /etc/ceph/admin.secret
# sudo chmod 600 /etc/ceph/admin.secret
# 
# # Kernel client (needs ceph.ko — may not work on NixOS)
# sudo mount -t ceph mon1:6789/ /mnt/bhole -o name=admin,secretfile=/etc/ceph/admin.secret
# sudo mount -t ceph 10.43.3.106:6789,10.43.19.14:6789,10.43.189.128:6789:/ /mnt/bhole \
#   -o name=admin,secretfile=/etc/ceph/admin.secret,mds_namespace=bholefs
# 
# # Or FUSE client (works everywhere)
# sudo ceph-fuse /mnt/bhole \
#   -n client.admin \
#   -k /etc/ceph/ceph.client.admin.keyring \
#   -m mon1:6789,mon2:6789,mon3:6789

Vdefault=$(kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- ceph fs subvolume getpath bholefs vicus-default --group_name colosseum | tr -d '\r')
Vprivate=$(kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- ceph fs subvolume getpath bholefs vicus-private --group_name colosseum | tr -d '\r')
Vdmz=$(kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- ceph fs subvolume getpath bholefs vicus-dmz --group_name colosseum | tr -d '\r')
Vpublic=$(kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- ceph fs subvolume getpath bholefs vicus-public --group_name colosseum | tr -d '\r')

echo "$Vdefault"
echo "$Vprivate"
echo "$Vdmz"
echo "$Vpublic"

# default
mkdir -p "/mnt/bhole${Vdefault}/technitium"
mkdir -p "/mnt/bhole${Vdefault}/gatus"
mkdir -p "/mnt/bhole${Vdefault}/dozzle"
mkdir -p "/mnt/bhole${Vdefault}/authentik"
mkdir -p "/mnt/bhole${Vdefault}/authentik/pgdata"
mkdir -p "/mnt/bhole${Vdefault}/authentik/media/public"
mkdir -p "/mnt/bhole${Vdefault}/netboot"
mkdir -p "/mnt/bhole${Vdefault}/openwrt"

mkdir -p "/mnt/bhole${Vdefault}/harbor"
mkdir -p "/mnt/bhole${Vdefault}/harbor/core-data"
mkdir -p "/mnt/bhole${Vdefault}/harbor/ca_download"
mkdir -p "/mnt/bhole${Vdefault}/harbor/registry"
mkdir -p "/mnt/bhole${Vdefault}/harbor/registry-root-crt"
mkdir -p "/mnt/bhole${Vdefault}/harbor/job_logs"
mkdir -p "/mnt/bhole${Vdefault}/harbor/trivy-adapter/trivy"
mkdir -p "/mnt/bhole${Vdefault}/harbor/trivy-adapter/reports"
mkdir -p "/mnt/bhole${Vdefault}/harbor/logs"
mkdir -p "/mnt/bhole${Vdefault}/harbor/pgdata"

# private
mkdir -p "/mnt/bhole${Vprivate}/gatus"

mkdir -p "/mnt/bhole${Vprivate}/monitor/dozzle"
mkdir -p "/mnt/bhole${Vprivate}/monitor/grafana"
mkdir -p "/mnt/bhole${Vprivate}/monitor/grafana/plugins"
mkdir -p "/mnt/bhole${Vprivate}/monitor/prometheus"
mkdir -p "/mnt/bhole${Vprivate}/monitor/headlamp"

mkdir -p "/mnt/bhole${Vprivate}/home/homeassistant/"

mkdir -p "/mnt/bhole${Vprivate}/code/ollama"
mkdir -p "/mnt/bhole${Vprivate}/code/vscodium"
mkdir -p "/mnt/bhole${Vprivate}/code/n8n"
mkdir -p "/mnt/bhole${Vprivate}/code/openclaw"
mkdir -p "/mnt/bhole${Vprivate}/code/odysseus"
mkdir -p "/mnt/bhole${Vprivate}/code/comfyui"
mkdir -p "/mnt/bhole${Vprivate}/code/webui"

# public
mkdir -p "/mnt/bhole${Vpublic}/gatus"

# dmz
mkdir -p "/mnt/bhole${Vdmz}/gatus"

mkdir -p "/mnt/bhole${Vdmz}/frontalt/searxng/"
mkdir -p "/mnt/bhole${Vdmz}/frontalt/invidious/"
mkdir -p "/mnt/bhole${Vdmz}/frontalt/invidious/pgdata"
mkdir -p "/mnt/bhole${Vdmz}/frontalt/invidious/companion-cache"
mkdir -p "/mnt/bhole${Vdmz}/frontalt/piped/"
mkdir -p "/mnt/bhole${Vdmz}/frontalt/piped/pgdata"

mkdir -p "/mnt/bhole${Vdmz}/cloud/immich/"
mkdir -p "/mnt/bhole${Vdmz}/cloud/immich/pgdata"

mkdir -p "/mnt/bhole${Vdmz}/oss/forgejo/"


mkdir -p "/mnt/bhole${Vdmz}/media-stack/"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/media"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/media/movies"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/media/tv"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/media/music"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/media/books"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/media/comics"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/media/videos"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/downloads"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/downloads/radarr"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/downloads/sonarr"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/downloads/lidarr"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/downloads/readarr"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/downloads/kapowarr"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/downloads/qbittorrent"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/downloads/unpackerr"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/jellyfin/config"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/jellyfin/cache"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/radarr/config"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/sonarr/config"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/lidarr/config"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/readarr/config"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/readarr/pgdata"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/kapowarr/db"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/prowlarr/config"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/jellyseerr/config"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/qbittorrent/config"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/tdarr/server"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/tdarr/configs"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/tdarr/logs"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/tdarr/temp"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/bazarr/config"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/autobrr/config"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/jellystat/data"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/jellystat/pgdata"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/unpackerr/config"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/profilarr/config"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/youtarr/config"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/youtarr/images"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/youtarr/jobs"
mkdir -p "/mnt/bhole${Vdmz}/media-stack/youtarr/mysql"


# chown
# sudo chown -R 70:70 "/mnt/bhole${Vdefault}/authentik"
# sudo chown -R 70:70 "/mnt/bhole${Vdefault}/harbor"

# sudo chown -R 70:70 "/mnt/bhole${Vdmz}/frontalt/invidious/"
# sudo chown -R 70:70 "/mnt/bhole${Vdmz}/frontalt/piped/"

# sudo chown -R 70:70 "/mnt/bhole${Vdmz}/cloud/immich/"

# sudo chown -R 70:70 "/mnt/bhole${Vdmz}/media-stack/jellystat/"
# sudo chown -R 70:70 "/mnt/bhole${Vdmz}/media-stack/readarr/"
# sudo chown -R 70:70 "/mnt/bhole${Vdmz}/media-stack/youtarr/"

sudo chown -R 1000:1000 "/mnt/bhole${Vprivate}/monitor/grafana"
sudo chown -R 65534:65534 "/mnt/bhole${Vprivate}/monitor/prometheus/"
