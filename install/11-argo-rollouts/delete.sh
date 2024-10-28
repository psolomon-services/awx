#!/usr/bin/env bash

NAMESPACE=argo-rollouts

echo
echo "installing argo-rollouts (in the ${NAMESPACE} namespace)"
echo helm install -n ${NAMESPACE} argo-rollouts argo/argo-rollouts -f values.txt
helm uninstall -n ${NAMESPACE} argo-rollouts 

echo
echo creating k8s namespace ${NAMESPACE}
kubectl delete ns ${NAMESPACE}

echo
kubectl get all -n ${NAMESPACE}
echo
