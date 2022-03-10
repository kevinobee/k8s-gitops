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
echo "Application credentials:"
export ARGOCD_PWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode)
echo "Argo CD:   ${ARGOCD_PWD}"
export LOKI_PWD=$(kubectl get secret --namespace monitoring loki-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode)
echo "Loki:      ${LOKI_PWD}"
K8S_TOKEN_NAME=$(kubectl get secret -n kubernetes-dashboard -o name | grep dashboard-admin-sa-token)
export K8S_TOKEN=$(kubectl get ${K8S_TOKEN_NAME} -n kubernetes-dashboard -o jsonpath='{.data.token}' | base64 --decode)
echo "Dashboard: ${K8S_TOKEN}"

echo
echo "To create GitOps application in Argo CD (App of Apps) run the command:"
echo
echo "   kubectl apply -k gitops"
echo
echo "Watch applications in Argo CD by running:"
echo
echo "   kubectl get applications.argoproj.io -n argocd -w"
echo
