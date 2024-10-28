#!/usr/bin/env bash

NS=jenkins
DEPLOY=jenkins

echo
echo restarting ${DEPLOY}
echo kubectl rollout restart -n ${NS} deploy ${DEPLOY}
kubectl rollout restart -n ${NS} statefulset ${DEPLOY}
