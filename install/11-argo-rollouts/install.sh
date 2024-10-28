#!/usr/bin/env bash

NS=argo-rollouts

echo
echo creating namespace ${NS}
echo kubectl create ns ${NS}
kubectl create ns ${NS}

USER=admin; PASSWORD=mywebpassword; echo "${USER}:$(openssl passwd -stdin -apr1 <<< ${PASSWORD})" > auth
cat auth
kubectl -n ${NS} create secret generic basic-auth --from-file=auth

echo
echo "installing ${NS} (in the ${NS} namespace)"
echo helm install -n ${NS} argo-rollouts argo/argo-rollouts -f values.txt
helm install -n ${NS} argo-rollouts argo/argo-rollouts -f values.txt --create-namespace
set -e

kubectl get all -n ${NS}
echo
