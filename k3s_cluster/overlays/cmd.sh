echo "kubectl apply -k ./production"
echo "kubectl delete deployment,cm,secret,ingress,pvc --all -n <namespace>"
echo "kubectl delete namespace <namespace>"

echo "sudo mount -t nfs 192.168.1.24:/bhole /mnt/bhole/"

echo "/home/k3su/infra/k3s_cluster/overlays/production # cat /etc/exports"
echo "/bhole 192.168.0.0/16(rw,async,wdelay,all_squash,anonuid=1000,anongid=1000,subtree_check)"
echo "/home/k3su/infra/k3s_cluster/overlays/production # exportfs -rav"

mkdir /bhole/cluster/default
mkdir /bhole/cluster/default/dozzle
mkdir /bhole/cluster/default/technitium


mkdir /bhole/cluster/private

mkdir /bhole/cluster/public

mkdir /bhole/cluster/dmz

sudo chown -R 1000:1000 /bhole/cluster/*

kubectl rollout restart deployment -n prod-dmz dmz-media-qbittorrent-deployment
