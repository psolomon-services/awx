#!/usr/bin/env bash

CERT_NAME=grafana-server-tls
HOSTNAME=pauljsolomon.net
SERVICE=grafana
DAYS=90
NS=monitoring

rm -f *.key *.crt

#            -newkey rsa:4096 \

echo
echo creating self-signed cert for ${SERVICE} server
openssl req -x509 \
            -newkey rsa \
            -sha256 \
            -nodes \
            -keyout ${CERT_NAME}.key \
            -out ${CERT_NAME}.crt \
            -subj "/CN=${SERVICE}.${HOSTNAME}/O=Paulco/OU=Libertyville" \
            -days ${DAYS}

echo
echo creating k8s secret
echo kubectl create secret tls ${SERVICE}-server-tls --cert=${CERT_NAME}.crt --key=${CERT_NAME}.key
kubectl create secret -n ${NS} tls ${SERVICE}-server-tls --cert=${CERT_NAME}.crt --key=${CERT_NAME}.key

echo
echo secret attrs
echo openssl x509 -in ${CERT_NAME}.crt -text -noout
openssl x509 -in ${CERT_NAME}.crt -text -noout | grep Issuer:
