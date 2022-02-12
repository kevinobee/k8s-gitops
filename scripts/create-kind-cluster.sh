#!/bin/bash
# create-kind-cluster.sh - uses the kind CLI to create a Kubernetes cluster using Docker

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
# set -x;

kind create cluster --config kind-config.yaml --wait 1m
kubectl wait node --all --for condition=ready
kubectl cluster-info --context kind-kind
# de-comment the next line to get detailed cluster info
# kubectl cluster-info dump

# sanity checks
kubectl get nodes -o wide
kubectl get pods --all-namespaces -o wide
kubectl get services --all-namespaces -o wide