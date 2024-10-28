#!/usr/bin/env bash
#
# see: https://metallb.universe.tf/installation/

NAMESPACE=metallb-system

echo
echo installing metallb
helm repo add metallb https://metallb.github.io/metallb
helm repo update

echo
echo creating k8s namespace ${NAMESPACE}
set +e
kubectl create ns ${NAMESPACE}
set -e

echo
echo helm install --force -n ${NAMESPACE} metallb metallb/metallb
helm install --force -n ${NAMESPACE} metallb metallb/metallb

# TODO: wait for metallb to be ready
sleep 10

echo
echo creating secret for memberlist
kubectl create secret generic -n ${NAMESPACE} memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

echo
echo setting up metallb ippools
kubectl apply -f .

echo
kubectl get all -n ${NAMESPACE}
echo
