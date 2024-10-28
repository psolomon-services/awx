#!/usr/bin/env bash

NS=cert-manager

echo
echo deleting cert-manager
helm delete cert-manager --namespace ${NS}

echo
kubectl get all -n ${NS}

