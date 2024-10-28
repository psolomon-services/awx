#!/usr/bin/env bash

NS=vault
POD=vault-0

echo
echo Vault Status
echo
echo kubectl exec -n ${NS} ${POD} -- vault status -tls-skip-verify
kubectl exec -n ${NS} ${POD} -- vault status -tls-skip-verify
echo
