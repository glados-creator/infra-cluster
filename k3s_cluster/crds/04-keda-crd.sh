set -x
# KEDA event-driven autoscaling
# https://keda.sh/docs/2.19/deploy/
kubectl create -f https://github.com/kedacore/keda/releases/download/v2.19.0/keda-2.19.0.yaml