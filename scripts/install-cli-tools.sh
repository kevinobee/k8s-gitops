#!/bin/bash
# install-cli-tools.sh - installs CLI tools for CI and automation scripts

# ref: https://kubernetes.io/docs/tasks/tools/

set -e

targetDir='/usr/local/bin/'

# kubectl
# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind ${targetDir}

# Datree
curl https://get.datree.io | /bin/bash

# Kubescape
curl -s https://raw.githubusercontent.com/armosec/kubescape/master/install.sh | /bin/bash

# kube-score
curl -Lo ./kube-score https://github.com/zegl/kube-score/releases/download/v1.13.0/kube-score_1.13.0_linux_amd64
chmod +x ./kube-score
sudo mv ./kube-score ${targetDir}