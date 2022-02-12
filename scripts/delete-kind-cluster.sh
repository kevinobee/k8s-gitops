#!/bin/bash
# delete-kind-cluster.sh - uses the kind CLI to delete a Kubernetes cluster

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
set -x;

kind delete cluster
