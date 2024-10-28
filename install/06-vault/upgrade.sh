#!/usr/bin/env bash

NS=vault

echo
echo upgrading vault
echo helm upgrade vault hashicorp/vault --namespace ${NS} --create-namespace --values values.txt
helm upgrade vault hashicorp/vault --namespace ${NS} --create-namespace --values values.txt

#echo
#echo upgrading external secrets
#echo helm upgrade kubernetes-external-secrets external-secrets/kubernetes-external-secrets --namespace ${NS} --create-namespace # --values values.txt
#helm upgrade kubernetes-external-secrets external-secrets/kubernetes-external-secrets --namespace ${NS} --create-namespace # --values values.txt
