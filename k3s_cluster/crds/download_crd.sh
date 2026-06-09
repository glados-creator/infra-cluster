set -x
# calico
# https://docs.tigera.io/calico/latest/getting-started/kubernetes/k3s/quickstart#big-picture
# https://docs.k3s.io/networking/basic-network-options?cni=Calico#custom-cni
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.32.0/manifests/v1_crd_projectcalico_org.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.32.0/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.32.0/manifests/custom-resources.yaml
# overide default value for ip forward + CIDR
kubectl apply -f ./calico.yaml

# traefik
# https://doc.traefik.io/traefik/reference/install-configuration/providers/kubernetes/kubernetes-crd/
# Install Traefik Resource Definitions:
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v3.7/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml
# Install RBAC for Traefik:
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v3.7/docs/content/reference/dynamic-configuration/kubernetes-crd-rbac.yml

# nvidia gpu runtime
# https://github.com/OlfillasOdikno/generic-cdi-plugin
kubectl apply -k ./nvidia

# vulcano gang scheduler
# https://volcano.sh/docs/GettingStarted/Installation
kubectl apply -f https://raw.githubusercontent.com/volcano-sh/volcano/master/installer/volcano-development.yaml

# metric server top api crd for dozzle
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# keda even driven actions
# https://keda.sh/docs/2.19/deploy/
kubectl apply --server-side -f https://github.com/kedacore/keda/releases/download/v2.19.0/keda-2.19.0.yaml

# prometheus monitoring
# https://prometheus-operator.dev/docs/getting-started/installation/ 
# kubectl create -f https://github.com/prometheus-operator/prometheus-operator/releases/download/v0.90.1/bundle.yaml

# mkdir -p prometheus-crd
# kubectl create namespace "prometheus-crd" 
# curl -s "https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/refs/tags/v0.90.1/kustomization.yaml" > "prometheus-crd/kustomization.yaml"
# curl -s "https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/refs/tags/v0.90.1/bundle.yaml" > "prometheus-crd/bundle.yaml"
# (cd prometheus-crd && kubectl set env namespace "prometheus-crd") && kubectl create -k "prometheus-crd"


# kubectl wait --for=condition=Ready pods -l  app.kubernetes.io/name=prometheus-operator
# kubectl set env namespace default 

# kubevirt 
# https://kubevirt.io/user-guide/cluster_admin/installation/
# export kubevirt_RELEASE=$(curl https://storage.googleapis.com/kubevirt-prow/release/kubevirt/kubevirt/stable.txt)
# cd kubevirt
# wget https://github.com/kubevirt/kubevirt/releases/download/${kubevirt_RELEASE}/kubevirt-operator.yaml
# wget https://github.com/kubevirt/kubevirt/releases/download/${kubevirt_RELEASE}/kubevirt-cr.yaml
# cd ..

# wait until all KubeVirt components are up
# $ kubectl -n kubevirt wait kv kubevirt --for condition=Available
# 
# kubectl edit -n kubevirt kubevirt kubevirt
# 
# Add the following to the kubevirt.yaml file
# 
# spec:
#     ...
#     configuration:
#         developerConfiguration:
#             useEmulation: true
# 
# kubectl get pods -n kubevirt

# rook 
# https://rook.io/docs/rook/latest/Getting-Started/quickstart/#cluster-environments
# git clone --single-branch --branch master https://github.com/rook/rook.git
# cd rook/deploy/examples
# kubectl create -f crds.yaml -f common.yaml -f csi-operator.yaml -f operator.yaml
# kubectl create -f cluster.yaml

# verify the rook-ceph-operator is in the `Running` state before proceeding
# kubectl -n rook-ceph get pod

# velero backup
# https://velero.io/docs/v1.8/customize-installation/
# idk
# velero dashboard
#  git clone https://github.com/otwld/velero-ui.git
#  cd velero-ui/kubernetes/manifests
# kubectl apply -f .
# kubectl port-forward service/velero-ui 3333:80 -n velero-ui