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
  "kubectx" \
  "kind" \
  "argocd"

  # optional tools
  # "argo" \
  # "octant" \
  # "kubeseal"
)

for i in "${brewTools[@]}"
do
  if [ ! $(which ${i}) ]; then
    echo "Installing ${i} CLI ... "
    brew install ${i}
  fi
done

if [ ! $(kind get clusters --quiet) ]; then
  echo "Create Kind cluster ..."
  kind create cluster --config kind-config.yaml --wait 1m
  kubectl wait node --all --for condition=ready
  kubectl cluster-info --context kind-kind
fi

if [[ ! $(kubectl get namespace | grep argocd) ]]; then
  echo "Install Argo CD ..."
  kubectl kustomize apps/argocd | kubectl apply -f -
  kubectl -n argocd wait --timeout 120s --for=condition=Available deployment argocd-server
fi

echo "Create GitOps application in Argo CD (App of Apps) ..."
kubectl apply -f gitops.yaml

echo
echo "Wait for Argo CD to sync applications ..."
kubens argocd
argocd app sync gitops

export ARGOCD_PWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)
echo
argocd admin dashboard &
kubens -
echo

