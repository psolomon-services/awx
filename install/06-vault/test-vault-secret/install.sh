#!/usr/bin/env bash

export VAULT_ADDR=https://vault.pauljsolomon.net

UNSEAL_FILE=../unseal-keys.txt
NS=test

#TOKEN=$(grep "Initial Root Token:" ${UNSEAL_FILE} | sed 's/Initial Root Token: //')
TOKEN=$(grep "Initial Root Token:" ${UNSEAL_FILE} | sed 's/Initial Root Token: //' | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g' | tr -d '\r' | tr -d '\n')
export VAULT_TOKEN=${TOKEN}

echo
echo creating namespace ${NS}
echo kubectl create ns ${NS}
kubectl create ns ${NS}

echo
echo creating vault test secret
echo vault kv put -tls-skip-verify /cubbyhole/foo bar=baz2
vault kv put -tls-skip-verify /cubbyhole/foo bar=baz2

echo
echo creating pod and external secrets
echo kubectl apply -f external-secret.yaml,test-pod,yaml
kubectl apply -f external-secret.yaml,test-pod.yaml

echo
echo waiting for pod to be ready
echo kubectl wait --for=condition=Ready -n ${NS} pod mypod
kubectl wait --for=condition=Ready -n ${NS} pod mypod

echo
echo checking pod secret
echo "kubectl exec -n ${NS} mypod -- env | grep MYSECRET"
kubectl exec -n ${NS} mypod -- env | grep MYSECRET
echo
