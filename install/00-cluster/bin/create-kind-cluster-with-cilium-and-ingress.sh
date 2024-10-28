#!/usr/bin/env bash

CLUSTER_NAME=main

echo
echo "Creating kind cluster $CLUSTER_NAME (for cilium, with kind ingress)"
kind create cluster --config conf/kind-cluster-with-cillium-and-ingress.yaml --name main

./install-cilium.sh

echo
kubectl get all -A
echo
