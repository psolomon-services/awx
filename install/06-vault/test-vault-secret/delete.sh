#!/usr/bin/env bash

NS=test

echo
echo kubectl delete ns ${NS}
kubectl delete ns ${NS}

echo
echo kubectl get all -n ${NS}
kubectl get all -n ${NS}
echo
