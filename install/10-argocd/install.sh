#!/usr/bin/env bash

# TO MAKE ARGOCD INSECURE
# see:  https://arnavtripathy98.medium.com/solution-how-to-deploy-argo-cd-dashboard-over-nginx-ingress-controller-926d8a540844
# https://arunsworld.medium.com/ssl-passthrough-via-kubernetes-ingress-b3eaf3c7c9da
#TODO:PSOLOMON make into a patch and restart

echo
echo installing argocd from helm
echo
echo helm repo add argo https://argoproj.github.io/argo-helm
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

NS=argocd

echo
echo creating namespace ${NS}
set +e
kubectl create ns ${NS}
set -e

echo
set +e
#echo helm install -n ${NS} argocd argo/argo-cd
#helm install -n ${NS} argocd argo/argo-cd

echo
echo installing argocd
echo helm install -n ${NS} argocd argo/argo-cd --create-namespace -f values.txt
helm install -n ${NS} argocd argo/argo-cd --create-namespace -f values.txt
set -e

#echo
#echo kubectl apply -f git-secret.yaml
#kubectl apply -f ./argocd-git-secret.yaml

# this is now called from the top-level script
#./install-finish.sh
