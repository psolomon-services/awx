#!/usr/bin/env bash

echo
echo "restarting pihole (rollout)"
echo kubectl rollout restart -n pihole pihole
kubectl -n pihole rollout restart deployment.apps/pihole

watch kubectl get all -n pihole
echo
