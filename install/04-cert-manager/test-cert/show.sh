#!/usr/bin/env bash

echo
echo ca.crt
kubectl get secret test-server-tls -o=jsonpath='{.data.ca\.crt}' | base64 -d; echo

echo
echo tls.crt
kubectl get secret test-server-tls -o=jsonpath='{.data.tls\.crt}' | base64 -d; echo

echo tls.key
kubectl get secret test-server-tls -o=jsonpath='{.data.tls\.key}' | base64 -d; echo

echo
