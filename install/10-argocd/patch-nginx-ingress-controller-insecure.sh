#!/usr/bin/env bash

INGRESS=deployment/ingress-nginx-controller

echo kubectl -n ingress-nginx patch ${INGRESS} --patch-file patch-nginx-ingress-controller-insecure.yml
kubectl -n ingress-nginx patch ${INGRESS} --patch-file patch-nginx-ingress-controller-insecure.yml
