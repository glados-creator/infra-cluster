conftest pull github.com/k-kinzal/kubernetes-relational-policy/

# format
find . -name "*.yaml" -exec yq eval -P -i {} \;

kubectl kustomize k3s_cluster/overlays/production| kube-linter lint -

# kubectl kustomize k3s_cluster/base/default/glance | conftest test --policy ./policy --combine - --trace
kubectl kustomize k3s_cluster/overlays/production | conftest test --policy ./policy -o table --all-namespaces --combine -