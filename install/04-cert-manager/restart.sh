#!/usr/bin/env bash

NS=awx
DEPLOY=cert-manager

echo
echo restarting awx web
echo kubectl rollout restart -n ${NS} deploy ${DEPLOY}
kubectl rollout restart -n ${NS} deploy ${DEPLOY}
