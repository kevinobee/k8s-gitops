#!/bin/bash
# create-kind-cluster.sh - uses the kind CLI to create a Kubernetes cluster using Docker

# standard bash error handling
set -o errexit;
set -o pipefail;
set -o nounset;
# debug commands
set -x;

kind create cluster --config kind-config.yaml --wait 1m
kubectl wait node --all --for condition=ready
kind get clusters
kubectl get nodes -o wide
