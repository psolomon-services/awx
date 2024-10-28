#!/usr/bin/env bash

NS=jenkins

echo
echo removing argocd proj/app
echo kubectl delete -f .
kubectl delete -f .

echo
echo removing namespace ${NS}
echo kubectl delete ns ${NS}
kubectl delete ns ${NS}

echo
echo kubectl get all -n ${NS}
kubectl get all -n ${NS}
echo
