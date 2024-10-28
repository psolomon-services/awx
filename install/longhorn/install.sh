#!/usr/bin/env bash

NS=longhorn-system

helm repo add longhorn https://charts.longhorn.io
helm repo update
helm install longhorn longhorn/longhorn --namespace ${NS} --create-namespace --version 1.6.2

USER=admin; PASSWORD=mywebpassword; echo "${USER}:$(openssl passwd -stdin -apr1 <<< ${PASSWORD})" >> auth
cat auth

kubectl -n ${NS} create secret generic basic-auth --from-file=auth

# vim ingress.yaml
# kubectl apply -f ingress.yaml 

# curl -H 'Host: longhorn.pauljsolomon.net' localhost
# curl -H 'Host: longhorn.pauljsolomon.net' localhost -u admin:mywebpassword

kubectl create -n ${NS} -f https://raw.githubusercontent.com/longhorn/longhorn/v1.6.2/examples/storageclass.yaml

