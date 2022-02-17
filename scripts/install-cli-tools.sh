#!/bin/bash
# install-cli-tools.sh - installs CLI tools for CI and automation scripts

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
  "datree" \
  "kubescape" \
  "kube-capacity" \
  "kube-score" \
  "linkerd" \
  "trivy"
)

for i in "${brewTools[@]}"
do

  if [ ! $(which ${i}) ]; then
    echo "Installing ${i} ... "
    brew install ${i}
  fi
done
