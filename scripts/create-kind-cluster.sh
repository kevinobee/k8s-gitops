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

echo
echo Cluster resources ...
kubectl resource-capacity

echo
echo Container resources ...
kubectl resource-capacity -c

echo
echo Pod resources ...
kubectl resource-capacity -p

# sanity checks
echo
echo Nodes ...
kubectl get nodes -o wide

echo
echo Pods ...
kubectl get pods --all-namespaces -o wide

echo
echo Services ...
kubectl get services --all-namespaces -o wide