#!/usr/bin/env bash

INGRESS=deployment/ingress-nginx-controller
GRPC=grpc.argocd.pauljsolomon.net

echo
echo Completing argocd setup

echo
echo "patching ingress controller (needed for grpc, for now)"
./patch-nginx-ingress-controller-insecure.sh

#./create-certs-and-secret.sh

echo
echo restarting ingress controller
echo kubectl rollout restart -n ingress-nginx ${INGRESS}
kubectl rollout restart -n ingress-nginx ${INGRESS}
sleep 4

echo
echo kubectl describe -n ingress-nginx ${INGRESS}
kubectl describe -n ingress-nginx ${INGRESS}

echo
echo setting argocd admin password
./set-argocd-admin-password.sh

echo
echo logging into argocd CLI
echo argocd login --insecure --username admin --password "mywebpassword" ${GRPC} --skip-test-tls
argocd login --insecure --username admin --password "mywebpassword" ${GRPC} --skip-test-tls

echo
echo adding private argocd-test repo to argocd
argocd repo add git@github.com:psolomon-services/argocd-test.git --ssh-private-key-path ~/.ssh/id_rsa --upsert
