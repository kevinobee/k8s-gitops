#!/bin/bash
# delete-kind-cluster.sh - uses the kind CLI to delete a Kubernetes cluster

set -e

kind delete cluster
