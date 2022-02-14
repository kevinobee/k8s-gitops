#!/bin/bash
# install-argocd.sh - install Argo CD in the cluster

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
# set -x;

echo Install Argo CD ...
kubectl kustomize apps/argocd/overlays/default | kubectl apply -f - --wait=true

kubectl rollout status -w deployment/argocd-dex-server -n argocd
kubectl rollout status -w deployment/argocd-redis -n argocd
kubectl rollout status -w deployment/argocd-repo-server -n argocd
kubectl rollout status -w deployment/argocd-server -n argocd

kubectl get svc -n argocd -o wide