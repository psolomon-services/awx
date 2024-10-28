#!/usr/bin/env bash

NS=argocd

echo
echo deleting ${NS}
echo helm delete -n ${NS} argocd
helm delete -n ${NS} argocd

echo
echo deleting namespace ${NS}
kubectl delete ns ${NS}

echo
echo kubectl get all -n ${NS}
kubectl get all -n ${NS}
echo
