#!/bin/bash
# install.sh - create k8s cluster and install GitOps applications

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
# set -x;

# Homebrew on Linux - ref: https://brew.sh/
if [ ! $(which brew) ]; then
  (
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  )
fi

brewTools=( \
  "kubectl" \
  "kind" \
  "argocd" \
  "argo"
)

for i in "${brewTools[@]}"
do
  if [ ! $(which ${i}) ]; then
    echo "Installing ${i} CLI ... "
    brew install ${i}
  fi
done

if [ ! $(kind get clusters --quiet) ]; then
  kind create cluster --config kind-config.yaml --wait 1m
  kubectl wait node --all --for condition=ready
  kubectl cluster-info --context kind-kind
fi

echo "Install applications ..."
kubectl kustomize apps/metallb | kubectl apply -f -
kubectl kustomize apps/ingress-nginx --enable-helm | kubectl apply -f -
kubectl kustomize apps/argocd --load-restrictor='LoadRestrictionsNone' | kubectl apply -f -
echo
echo "Wait for deployments ..."
kubectl -n argocd wait --timeout 120s --for=condition=Available deployment argocd-server

echo "Create GitOps application in Argo CD (App of Apps) ..."
kubectl apply -f gitops.yaml

echo
kubectl port-forward svc/argocd-server -n argocd 8080:443 &
pwd=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo)
argocd login localhost:8080 --insecure --username admin --password ${pwd}
export ARGOCD_PWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)
echo
echo "Argo CD:     http://localhost:8080"
echo "Credentials: ${ARGOCD_PWD}"
echo
echo "Wait for Argo CD to Sync Applications ..."
argocd app wait gitops
kubectl -n ingress-nginx wait --timeout=120s --for=condition=Available deployment ingress-nginx-controller
kubectl -n ingress-nginx wait --timeout=200s --for=condition=ready pod --selector=app.kubernetes.io/component=controller
echo
kubectl get ing -A
