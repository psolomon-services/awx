#!/usr/bin/env bash

NS=pihole

echo
echo deleting helm in argocd
echo kubectl delete -f .
kubectl delete -f .

echo
echo deleting ns ${NS}
echo kubectl delete ns ${NS}
kubectl delete ns ${NS}

echo
echo remaining resource in namespace ${NS}
kubectl get all -n ${NS}
