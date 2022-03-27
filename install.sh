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
  "linkerd"

  # useful tools:
  #   "argo"
  #   "kubectx"
  #   "kubeseal
  #   "octant"
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

if [[ ! $(kubectl get namespace | grep linkerd) ]]; then
  echo "Install Service Mesh ..."
  linkerd install | kubectl apply -f -
  linkerd check
  linkerd viz install | kubectl apply -f -
fi

if [[ ! $(kubectl get namespace | grep argocd) ]]; then
  echo "Install Argo CD ..."
  kubectl kustomize apps/argocd | kubectl apply -f -
  kubectl -n argocd wait --timeout 120s --for=condition=Available deployment argocd-server
fi

kubectl port-forward svc/argocd-server -n argocd 8080:443 1>/dev/null 2>&1 &
export ARGOCD_PWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)
argocd login localhost:8080 --insecure --username admin --password ${ARGOCD_PWD}

echo
echo "Create GitOps application in Argo CD (App of Apps) ..."
kubectl apply -f gitops.yaml

echo
echo "Wait for Argo CD to sync applications ..."
sleep 5s
argocd app sync gitops

argocd admin dashboard -n argocd 1>/dev/null 2>&1 &

echo
echo "Argo CD:     https://localhost:8080"
echo "Credentials: ${ARGOCD_PWD}"
echo
