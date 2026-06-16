echo "kubectl apply -k ./production"
echo "kubectl delete deployment,cm,secret,ingress,pvc --all -n <namespace>"
echo "kubectl delete namespace <namespace>"

echo "sudo mount -t nfs 192.168.1.24:/bhole /mnt/bhole/"

echo "/home/k3su/infra/k3s_cluster/overlays/production # cat /etc/exports"
echo "/bhole 192.168.0.0/16(rw,async,wdelay,all_squash,anonuid=1000,anongid=1000,subtree_check)"
echo "/home/k3su/infra/k3s_cluster/overlays/production # exportfs -rav"

mkdir /bhole/cluster/default
mkdir /bhole/cluster/default/technitium


mkdir /bhole/cluster/private
mkdir /bhole/cluster/private/dozzle
mkdir /bhole/cluster/private/gatus
mkdir /bhole/cluster/private/code/webui

mkdir /bhole/cluster/public
mkdir /bhole/cluster/public/gatus

mkdir /bhole/cluster/dmz
mkdir /bhole/cluster/dmz/gatus
mkdir /bhole/cluster/dmz/media-stack/
mkdir /bhole/cluster/dmz/media-stack/media
mkdir /bhole/cluster/dmz/media-stack/media/movies
mkdir /bhole/cluster/dmz/media-stack/media/tv
mkdir /bhole/cluster/dmz/media-stack/media/music
mkdir /bhole/cluster/dmz/media-stack/media/books
mkdir /bhole/cluster/dmz/media-stack/media/comics
mkdir /bhole/cluster/dmz/media-stack/media/movies
mkdir /bhole/cluster/dmz/media-stack/downloads
mkdir /bhole/cluster/dmz/media-stack/downloads/radarr
mkdir /bhole/cluster/dmz/media-stack/downloads/sonarr
mkdir /bhole/cluster/dmz/media-stack/downloads/lidarr
mkdir /bhole/cluster/dmz/media-stack/downloads/readarr
mkdir /bhole/cluster/dmz/media-stack/downloads/kapowarr
mkdir /bhole/cluster/dmz/media-stack/downloads/qbittorrent
mkdir /bhole/cluster/dmz/media-stack/downloads/unpackerr
mkdir /bhole/cluster/dmz/media-stack/jellyfin/config
mkdir /bhole/cluster/dmz/media-stack/jellyfin/cache
mkdir /bhole/cluster/dmz/media-stack/radarr/config
mkdir /bhole/cluster/dmz/media-stack/sonarr/config
mkdir /bhole/cluster/dmz/media-stack/lidarr/config
mkdir /bhole/cluster/dmz/media-stack/readarr/config
mkdir /bhole/cluster/dmz/media-stack/kapowarr/db
mkdir /bhole/cluster/dmz/media-stack/prowlarr/config
mkdir /bhole/cluster/dmz/media-stack/jellyseerr/config
mkdir /bhole/cluster/dmz/media-stack/qbittorrent/config
mkdir /bhole/cluster/dmz/media-stack/tdarr/server
mkdir /bhole/cluster/dmz/media-stack/tdarr/configs
mkdir /bhole/cluster/dmz/media-stack/tdarr/logs
mkdir /bhole/cluster/dmz/media-stack/tdarr/temp
mkdir /bhole/cluster/dmz/media-stack/bazarr/config
mkdir /bhole/cluster/dmz/media-stack/autobrr/config
mkdir /bhole/cluster/dmz/media-stack/jellystat/data
mkdir /bhole/cluster/dmz/media-stack/unpackerr/config
mkdir /bhole/cluster/dmz/media-stack/profilarr/config
mkdir /bhole/cluster/dmz/media-stack/youtarr/config

sudo chown -R 1000:1000 /bhole/cluster/*

kubectl rollout restart deployment -n prod-dmz dmz-media-qbittorrent-deployment


# rm -rf /var/log/calico                                                                                                                                   
# rm -rf /var/lib/calico                                                                                                                                   
# rm -rf /etc/cni                                                                                                                                          
# rm -rf /opt/cni                                                                                                                                          
# rm -rf /var/log/containers                                                                                                                               /home/k3su/infra-cluster/k3s_cluster/crds # rm -rf /var/log/pods 

# clear iptable for uninstall-reinstall
# iptables-restore: COMMIT expected
# iptables -F
# iptables -X
# iptables -P INPUT ACCEPT
# iptables -P OUTPUT ACCEPT
# iptables -P FORWARD ACCEPT
# iptables-save

# ip6tables -F
# ip6tables -X
# ip6tables -P INPUT ACCEPT
# ip6tables -P OUTPUT ACCEPT
# ip6tables -P FORWARD ACCEPT
# ip6tables-save
