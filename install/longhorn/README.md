# Helm Values

* https://github.com/longhorn/longhorn/blob/master/chart/values.yaml


# Guide

* https://longhorn.io/docs/1.6.2/deploy/install/install-with-helm/

helm repo add longhorn https://charts.longhorn.io
helm repo update
helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version 1.6.2

USER=admin; PASSWORD=mywebpassword; echo "${USER}:$(openssl passwd -stdin -apr1 <<< ${PASSWORD})" >> auth
cat auth

kubectl -n longhorn-system create secret generic basic-auth --from-file=auth

vim ingress.yaml
kubectl apply -f ingress.yaml 

curl -H 'Host: longhorn.pauljsolomon.net' localhost
curl -H 'Host: longhorn.pauljsolomon.net' localhost -u admin:mywebpassword

