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
  "argocd"
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
kubectl kustomize apps --enable-helm | kubectl apply -f -
echo
echo "Wait for deployments ..."
kubectl -n argocd wait --timeout 120s --for=condition=Available deployment argocd-server
kubectl -n ingress-nginx wait --timeout=120s --for=condition=Available deployment ingress-nginx-controller
kubectl -n ingress-nginx wait --timeout=200s --for=condition=ready pod --selector=app.kubernetes.io/component=controller
echo
kubectl get ing -A

echo
echo "To create GitOps application in Argo CD (App of Apps) run the command:"
echo
echo "   kubectl apply -k gitops"
echo
echo "Watch applications in Argo CD by running:"
echo
echo "   kubectl get applications.argoproj.io -n argocd -w"
echo