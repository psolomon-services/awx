#!/usr/bin/env bash

# info on patching
# https://gist.github.com/dnaprawa/52b5ed9af014626764afda5be6de2a34

echo
echo deleting metrics server
echo helm delete metrics-server
helm delete metrics-server

sleep 3

echo
kubectl get pod -n kube-system --selector=app.kubernetes.io/name=metrics-server
echo
