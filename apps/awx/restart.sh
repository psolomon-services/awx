#!/usr/bin/env bash

NS=awx
DEPLOY_LIST="awx-demo-web awx-demo-task"

for DEPLOY in ${DEPLOY_LIST}
do
  echo
  echo restarting awx ${DEPLOY}
  echo kubectl rollout restart -n ${NS} deploy ${DEPLOY}
  kubectl rollout restart -n ${NS} deploy ${DEPLOY}
done
