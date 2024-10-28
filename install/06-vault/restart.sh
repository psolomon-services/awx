#!/usr/bin/env bash

NS=vault

echo
echo restarting services
echo kubectl rollout restart -n ${NS} deployment.apps/vault-agent-injector
kubectl rollout restart -n ${NS} deployment.apps/vault-agent-injector

echo
echo kubectl rollout restart -n ${NS} statefulset.apps/vault
kubectl rollout restart -n ${NS} statefulset.apps/vault

echo
echo kubectl get all -n ${NS}
kubectl get all -n ${NS}
echo
