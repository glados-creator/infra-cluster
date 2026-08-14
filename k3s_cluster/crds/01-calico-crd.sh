set -x
# calico
# https://docs.tigera.io/calico/latest/getting-started/kubernetes/k3s/quickstart#big-picture
# https://docs.k3s.io/networking/basic-network-options?cni=Calico#custom-cni
kubectl apply --server-side -f https://raw.githubusercontent.com/projectcalico/calico/v3.32.0/manifests/v1_crd_projectcalico_org.yaml
sleep 1
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.32.0/manifests/tigera-operator.yaml
sleep 1
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.32.0/manifests/custom-resources.yaml
# overide default value for ip forward + CIDR
sleep 1
kubectl apply -f ./calico.yaml
sleep 1