#!/usr/bin/env bash
#
# See:  https://dustinspecker.com/posts/test-ingress-in-kind/
#   (they use the static files, instead of helm)

NS=ingress-nginx

echo
echo deleting ${NS} config
kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

echo
echo deleting namespace $[NS}
echo kubectl delete ns ${NS}
kubectl delete ns ${NS}

echo
kubectl get all -n ${NS}
echo
