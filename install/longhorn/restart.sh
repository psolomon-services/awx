#!/usr/bin/env bash

NS=longhorn-system

echo
echo restarting argocd server
echo kubectl rollout restart -n ${NS} daemonset.apps/longhorn-manager
kubectl rollout restart -n ${NS} daemonset.apps/longhorn-manager
