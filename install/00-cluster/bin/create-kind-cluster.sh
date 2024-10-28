#!/usr/bin/env bash

CLUSTER_NAME=main

echo
echo "Creating kind cluster $CLUSTER_NAME (standard cluster)"
echo kind create cluster --config conf/kind-cluster.yaml --name main
kind create cluster --config conf/kind-cluster.yaml --name main
