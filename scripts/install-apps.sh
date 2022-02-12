#!/bin/bash
# install-apps.sh - install apps folder to cluster

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
# set -x;

echo Build and apply YAML to the cluster ...
while ! (kubectl apply -k apps --wait=true); do
  sleep 1m
done

echo
echo Waiting for Ingress to be available ...
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

echo
kubectl get ingress -A
