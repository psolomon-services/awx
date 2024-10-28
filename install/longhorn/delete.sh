#!/usr/bin/env bash

NS=longhorn-system

# https://longhorn.io/docs/1.6.2/deploy/uninstall/#prerequisite

echo
echo patching longhorn to undo delete protections
echo kubectl -n ${NS} patch -p '{"value": "true"}' --type=merge lhs deleting-confirmation-flag
kubectl -n ${NS} patch -p '{"value": "true"}' --type=merge lhs deleting-confirmation-flag

echo
echo deleting longhorn via helm
echo helm delete longhorn -n ${NS}
helm delete longhorn -n ${NS}

echo
echo deleting ns ${NS}
echo kubectl delete ns ${NS}
kubectl delete ns ${NS}

echo
echo kubectl get all -ns ${NS}
kubectl get all -ns ${NS}
