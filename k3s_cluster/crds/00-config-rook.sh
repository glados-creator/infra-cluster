ceph auth get-or-create client.healthchecker \
  mon 'allow r, allow command quorum_status, allow command version' \
  mgr 'allow command config'
ceph auth print-key client.healthchecker

kubectl -n rook-ceph create secret generic rook-csi-cephfs-node \
  --from-literal=userID=bhole \
  --from-literal=userKey=$(cat /etc/ceph/bhole.secret)