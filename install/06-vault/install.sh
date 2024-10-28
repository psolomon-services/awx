#!/usr/bin/env bash

NS=vault
UNSEAL_FILE=unseal-keys.txt
VAULT_ADDR=https://vault.pauljsolomon.net

echo
echo "installing vault (in the ${NS} namespace)"

set +e
echo helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo add hashicorp https://helm.releases.hashicorp.com

echo
echo helm install vault hashicorp/vault --namespace ${NS} --create-namespace
helm install vault hashicorp/vault --namespace ${NS} --create-namespace -f values.txt

# TODO:psolomon kubectl wait for pod Running does not work
echo
echo waiting for vault pod to be ready

sleep 10

echo
echo initializing vault
echo "kubectl -n vault exec vault-0 -- vault operator init > ${UNSEAL_FILE}"
kubectl -n vault exec vault-0 -- vault operator init > ${UNSEAL_FILE}

echo
echo vault keys are stored in ${UNSEAL_FILE}

# see: https://github.com/hashicorp/vault/issues/3869
# to see the hidden characters:  echo ${LINE} | cat -v

TOKEN=$(grep "Initial Root Token:" ${UNSEAL_FILE} | sed 's/Initial Root Token: //' | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g' | tr -d '\r' | tr -d '\n')
#export VAULT_TOKEN=${TOKEN}

echo
echo creating secret for token
echo "kubectl create secret generic vault-token --from-literal=key1=*******"
# TODO:  cannot read this from other namespaces
echo kubectl delete secret vault-token -n ${NS}
kubectl delete secret vault-token -n ${NS}

echo "kubectl create secret generic vault-token --from-literal=token=********* #-n ${NS}"
kubectl create secret generic vault-token --from-literal=token=${TOKEN} -n ${NS}

echo
echo creating clusterrolebinding
echo kubectl apply -f crolebinding.yaml
kubectl apply -f crolebinding.yaml

NS2=external-secrets

echo
echo installing external secrets into namespace ${NS2}

# deprecated, moved to the one below
#echo helm repo add external-secrets https://godaddy.github.io/kubernetes-external-secrets/
#helm repo add external-secrets https://godaddy.github.io/kubernetes-external-secrets/

echo helm repo add external-secrets https://charts.external-secrets.io
helm repo add external-secrets https://charts.external-secrets.io

echo helm install external-secrets external-secrets/external-secrets -n ${NS2} --create-namespace --set installCRDs=true
helm install external-secrets external-secrets/external-secrets -n ${NS2} --create-namespace --set installCRDs=true

set -e

./install-finish.sh
