#!/bin/bash
# test.sh - create cluster, populate apps and run test on the cluster

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
# set -x;

scripts/create-kind-cluster.sh
scripts/install-apps.sh
scripts/test-apps.sh
