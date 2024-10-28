#!/usr/bin/env bash

NS=monitoring
DEPLOY=grafana

echo
echo restarting awx web
echo kubectl rollout restart -n ${NS} deploy ${DEPLOY}
kubectl rollout restart -n ${NS} deploy ${DEPLOY}
