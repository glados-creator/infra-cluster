set -x
bash 01-calico-crd.sh
kubectl apply -k 02-base
kubectl apply -k 03-install
bash 00-config-rook.sh
bash 04-keda-crd.sh
# bash 05-linkerd-crd.sh
kubectl apply -k 06-gpu-operator
kubectl apply -k 07-config

# linkerd check