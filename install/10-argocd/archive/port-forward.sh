#!/usr/bin/env bash

echo
echo kubectl port-forward svc/argocd-server --address 0.0.0.0 -n argocd 8080:443 IN BACKGROUND
nohup kubectl port-forward svc/argocd-server --address 0.0.0.0 -n argocd 8080:443 2> /dev/null &
