#!/usr/bin/env bash

NS=cert-manager
SLEEP=20

echo
echo installing cert-manager
echo helm repo add jetstack https://charts.jetstack.io --force-update
helm repo add jetstack https://charts.jetstack.io --force-update
helm install cert-manager jetstack/cert-manager --namespace ${NS} --create-namespace --version v1.15.1 --set crds.enabled=true

echo
echo sleeping for ${SLEEP} seconds to wait for cert-manager start
sleep ${SLEEP}

echo
echo applyng cert manager issuers
kubectl apply -f .

echo
kubectl get all -n ${NS}

