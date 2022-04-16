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
  "linkerd" \
  "octant"
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

echo
echo "Install Service Mesh ..."
kubectl kustomize apps/linkerd | kubectl apply -f -
linkerd check

echo
echo "Install Argo CD ..."
kubectl kustomize apps/argocd | kubectl apply -f -
for deploy in "dex-server" "redis" "repo-server" "server"; \
  do kubectl -n argocd rollout status deploy/argocd-${deploy}; \
done
kubectl -n argocd rollout status statefulset/argocd-application-controller

kubectl -n argocd port-forward svc/argocd-server 8080:443 > /dev/null 2>&1 &
export ARGOCD_PWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)
argocd login localhost:8080 --insecure --username admin --password ${ARGOCD_PWD}

echo
echo
echo "To open the Argo CD dashboard run:"
echo
echo "argocd admin dashboard -n argocd"
echo
echo "   user:     admin"
echo "   password: ${ARGOCD_PWD}"
echo
echo
echo "To create GitOps application in Argo CD (App of Apps) run:"
echo
echo "kubectl apply -f gitops.yaml"
echo "argocd app sync gitops"
echo "argocd app wait gitops --health"
echo "argocd app sync -l app.kubernetes.io/instance=gitops"
echo "argocd app wait -l app.kubernetes.io/instance=gitops --sync"
echo
echo
echo "To open the Linkerd UI run:"
echo
echo "linkerd viz install | kubectl apply -f -"
echo "linkerd viz check"
echo "linkerd viz dashboard &"
echo
echo
echo "To install useful CLI tools run:"
echo
echo "brew install argo kubectx kubeseal"
echo
echo
echo "To manually install applications into the cluster run:"
echo
echo "kubectl kustomize --enable-helm apps | k apply -f -"
echo
