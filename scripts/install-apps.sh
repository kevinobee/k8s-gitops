#!/bin/bash
# install-apps.sh - install apps folder to cluster

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
# set -x;

echo Build and apply YAML to the cluster ...
while ! (kubectl kustomize apps --enable-helm | kubectl apply -f - --wait=true); do
  sleep 15s
  kubectl rollout status -w deployment/gatekeeper-policy-manager -n gatekeeper-system
done

echo
echo Waiting for Ingress to be available ...
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

echo
kubectl get ingress -A