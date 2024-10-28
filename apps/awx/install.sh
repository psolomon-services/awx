#!/usr/bin/env bash

echo
echo Installing AWX via argocd/Application

echo
echo applying argocd application for awx
echo kubectl apply -f awx-proj.yaml,awx-app.yaml
kubectl apply -f awx-proj.yaml,awx-app.yaml

sleep 4

echo
./follow.sh

