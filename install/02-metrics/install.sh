# info on patching
# https://gist.github.com/dnaprawa/52b5ed9af014626764afda5be6de2a34

helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update

helm upgrade --install metrics-server metrics-server/metrics-server -n kube-system --create-namespace

sleep 3

echo
echo patching metrics-server for insecure operation
echo "kubectl patch deployment metrics-server -n kube-system --type 'json' -p '[{'op': 'add', 'path': '/spec/template/spec/containers/0/args/-', 'value': '--kubelet-insecure-tls'}]'"
kubectl patch deployment metrics-server -n kube-system --type 'json' -p '[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'

sleep 5

#echo
#echo waiting for metrics server pod to be ready
#kubectl wait --namespace kube-system \
#  --for=condition=ready pod \
#  --selector=app.kubernetes.io/name=metrics-server

echo
kubectl get pod -n kube-system --selector=app.kubernetes.io/name=metrics-server
echo
