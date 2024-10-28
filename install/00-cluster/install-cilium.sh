#!/usr/bin/env bash

#IMAGE=cilium/cilium:v1.9.1
#CILIUM_VERSION=1.10.1
IMAGE=cilium/cilium:v1.15.6
CILIUM_VERSION=1.15.6

helm repo add cilium https://helm.cilium.io
helm repo update

echo
echo installing cilium from helm
echo helm install cilium cilium/cilium --version ${CILIUM_VERSION} --namespace kube-system
helm install cilium cilium/cilium --version ${CILIUM_VERSION} --namespace kube-system

echo
echo pulling image ${IMAGE}
docker pull ${IMAGE}

echo
echo pushing image ${IMAGE} to kind cluster
kind load --name main docker-image ${IMAGE}

echo
kubectl get all -n kube-system
echo
