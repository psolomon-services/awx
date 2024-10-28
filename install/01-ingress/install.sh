#!/usr/bin/env bash
#
# See:  https://dustinspecker.com/posts/test-ingress-in-kind/
#   (they use the static files, instead of helm)

NS=ingress-nginx

echo
echo installing namespace ${NS}
kubectl delete ns ${NS}

echo
echo installing ${NS}
echo kubectl apply --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
kubectl apply --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml


echo
kubectl get all -n ${NS}
echo
