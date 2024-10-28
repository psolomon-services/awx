#!/usr/bin/env bash

NS=argocd

echo
echo helm upgrade -n ${NS} argocd argo/argo-cd --create-namespace -f values.txt
helm upgrade -n ${NS} argocd argo/argo-cd --create-namespace -f values.txt
