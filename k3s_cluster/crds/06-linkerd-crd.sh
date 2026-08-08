set -ex 

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
curl --proto '=https' --tlsv1.2 -sSfL https://run.linkerd.io/install-edge | sh
export PATH=$HOME/.linkerd2/bin:$PATH
linkerd install --crds | kubectl apply -f -
linkerd install | kubectl apply -f -
linkerd viz install | kubectl apply -f -

# TODO config linkerd .... and linkerd viz web 