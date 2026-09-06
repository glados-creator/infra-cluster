set -x
# calico
# https://docs.tigera.io/calico/latest/getting-started/kubernetes/k3s/quickstart#big-picture
# https://docs.k3s.io/networking/basic-network-options?cni=Calico#custom-cni
# https://docs.tigera.io/calico/latest/getting-started/kubernetes/nftables
kubectl apply --server-side -f https://raw.githubusercontent.com/projectcalico/calico/v3.32.2/manifests/v1_crd_projectcalico_org.yaml
sleep 1
kubectl apply -f ./calico.yaml
sleep 1
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.32.2/manifests/tigera-operator.yaml
sleep 1
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.32.2/manifests/custom-resources.yaml
sleep 1
# overide default value for ip forward + CIDR
sleep 1
kubectl apply -f ./felix.yaml