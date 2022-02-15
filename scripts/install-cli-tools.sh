#!/bin/bash
# install-cli-tools.sh - installs CLI tools for CI and automation scripts

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
# set -x;

targetDir='/usr/local/bin/'

# kind - ref: https://kind.sigs.k8s.io/docs/user/quick-start/
if [ ! $(which kind) ]; then
  (
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
    chmod +x ./kind
    sudo mv ./kind ${targetDir}
  )
fi
kind version
echo

# krew - ref: https://krew.sigs.k8s.io/docs/user-guide/setup/install/
# macOS/Linux
# Bash or ZSH shells
# requires that git is installed
kubectl krew > /dev/null 2>&1
if [ $? -ne 0 ]; then
  (
    set -x; cd "$(mktemp -d)" &&
    OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
    KREW="krew-${OS}_${ARCH}" &&
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
    tar zxvf "${KREW}.tar.gz" &&
    ./"${KREW}" install krew
  )
  # add the $HOME/.krew/bin directory to your PATH environment variable
  export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi

# kube-capacity - ref: https://github.com/robscott/kube-capacity
kubectl krew install resource-capacity
kubectl resource-capacity version
echo

# Argo CD - ref: https://argo-cd.readthedocs.io/en/stable/cli_installation/
if [ ! $(which argocd) ]; then
  (
    curl -Lo ./argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
    chmod +x ./argocd
    sudo mv ./argocd ${targetDir}
  )
fi
argocd version --client
echo

# Trivy- ref: https://aquasecurity.github.io/trivy/v0.23.0/getting-started/installation/
if [ ! $(which trivy) ]; then
  (
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin v0.23.0
  )
fi
echo "Trivy:"
trivy --version

# # Datree
# curl https://get.datree.io | /bin/bash

# # Kubescape
# curl -s https://raw.githubusercontent.com/armosec/kubescape/master/install.sh | /bin/bash

# # kube-score
# curl -Lo ./kube-score https://github.com/zegl/kube-score/releases/download/v1.13.0/kube-score_1.13.0_linux_amd64
# chmod +x ./kube-score
# sudo mv ./kube-score ${targetDir}
