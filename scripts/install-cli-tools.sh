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
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind ${targetDir}

# # Datree
# curl https://get.datree.io | /bin/bash

# # Kubescape
# curl -s https://raw.githubusercontent.com/armosec/kubescape/master/install.sh | /bin/bash

# # kube-score
# curl -Lo ./kube-score https://github.com/zegl/kube-score/releases/download/v1.13.0/kube-score_1.13.0_linux_amd64
# chmod +x ./kube-score
# sudo mv ./kube-score ${targetDir}