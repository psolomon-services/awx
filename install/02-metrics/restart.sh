#!/usr/bin/env bash

NS=kube-system

echo
echo restarting metrics server
kubectl rollout restart -n ${NS} deploy metrics-server
