#!/bin/bash
# test.sh - create cluster, populate apps, test ingress and delete cluster

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
set -x;

# scripts/install-cli-tools.sh
scripts/create-kind-cluster.sh
scripts/install-apps.sh
scripts/test-apps.sh
scripts/delete-kind-cluster.sh


