#!/usr/bin/env bash

NS=monitoring

echo
echo creating namespace ${NS}
kubectl create ns ${NS}

echo
echo installing grafana in argocd
kubectl apply -f grafana-proj.yaml,grafana-app.yaml

watch kubectl get all -n ${NS}
echo
