#!/usr/bin/env bash
#
# TODO:PSOLOMON check if cluster already exists and act accordingly

CLUSTER=main

echo
echo "Creating kind cluster ${CLUSTER} (with ingress)"
echo kind create cluster --config conf/kind-cluster-ingress.yaml --name ${CLUSTER}
kind create cluster --config conf/kind-cluster-ingress.yaml --name ${CLUSTER}
