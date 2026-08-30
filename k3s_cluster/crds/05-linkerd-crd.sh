set -ex 

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
curl --proto '=https' --tlsv1.2 -sSfL https://run.linkerd.io/install-edge | sh
export PATH=$HOME/.linkerd2/bin:$PATH
linkerd install --crds | kubectl apply -f -
# linkerd install | kubectl apply -f -
linkerd install \
  --set "proxyInit.iptablesMode=nft" \
  --set prometheus.enabled=false \
  --set prometheusUrl=http://private-monitor-prometheus-service.prod-private.svc.cluster.local:4420 \
  --set web.enforcedHostRegex='^(localhost|0\.0\.0\.0|web\.linkerd-viz\.svc\.cluster\.local|web\.linkerd-viz\.svc|\[::1\]|linkerd\.main\.home)(:\d+)?$' \
  | kubectl apply -f -
# linkerd viz install | kubectl apply -f -
linkerd viz install \
  --set "proxyInit.iptablesMode=nft" \
  --set prometheus.enabled=false \
  --set prometheusUrl=http://private-monitor-prometheus-service.prod-private.svc.cluster.local:4420 \
  --set web.enforcedHostRegex='^(localhost|0\.0\.0\.0|web\.linkerd-viz\.svc\.cluster\.local|web\.linkerd-viz\.svc|\[::1\]|linkerd\.main\.home)(:\d+)?$' \
  | kubectl apply -f -
linkerd check