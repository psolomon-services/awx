#!/usr/bin/env bash

NS=vault

echo
echo deleting k8s resources
echo kubectl delete -f .
kubectl delete -f .

set +e
NS2=external-secrets

echo
echo helm delete external-secrets -n ${NS2}
helm delete external-secrets -n ${NS2}

echo
echo helm delete vault --namespace ${NS}
helm delete vault -n ${NS}

echo
echo kubectl delete ns ${NS2}
kubectl delete ns ${NS2}

NS2=external-secrets
echo kubectl delete ns ${NS}
kubectl delete ns ${NS}

set -e

echo
echo kubectl get all -n ${NS}
kubectl get all -n ${NS}
echo
echo kubectl get all -n ${NS2}
kubectl get all -n ${NS2}
echo
