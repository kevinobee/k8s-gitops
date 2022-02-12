#!/bin/bash
# create-kind-cluster.sh - uses the kind CLI to create a Kubernetes cluster using Docker

set -e

kind create cluster --config kind-config.yaml
kind get clusters
kubectl get nodes -o wide
