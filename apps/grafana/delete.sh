#!/usr/bin/env bash

NS=monitoring

echo
echo deleting prometheus stack
echo kubectl delete -f .
kubectl delete -f .

echo
echo deleting namespace ${NS}
echo kubectl delete ns ${NS}
kubectl delete ns ${NS}

sleep 2
kubectl get all -n ${NS}
echo
