#!/usr/bin/env bash

NS=argo-rollouts

echo
echo "upgrading argo-rollouts (in the ${NS} namespace)"
echo helm upgrade -n ${NS} argo-rollouts argo/argo-rollouts -f values.txt --create-namespace
helm upgrade -n ${NS} argo-rollouts argo/argo-rollouts -f values.txt --create-namespace
set -e

kubectl get all -n ${NS}
echo
