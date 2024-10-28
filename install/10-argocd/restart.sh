#!/usr/bin/env bash

NS=argocd
#DEPLOY=argocd-server

#echo
#echo restarting argocd server
#echo kubectl rollout restart -n ${NS} deploy ${DEPLOY}
#kubectl rollout restart -n ${NS} deploy ${DEPLOY}

#deployment.apps/argocd-applicationset-controller   1/1     1            1           2d3h


APPS="applicationset-controller dex-server notifications-controller redis repo-server server"

for APP in ${APPS}
do
  echo
  echo restarting ${NS}:${APP}
  echo kubectl rollout restart -n ${NS} deploy argocd-${APP}
  kubectl rollout restart -n ${NS} deploy argocd-${APP}
done

kubectl get all -n ${NS}
echo
