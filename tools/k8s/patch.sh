#!/usr/bin/env bash

NS=monitoring

#kubectl edit -n monitoring service/grafana

echo
echo patching
#kubectl patch deployment metrics-server -n kube-system --type 'json' -p '[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'
kubectl patch service/grafana -n monitoring --type 'json' -p '[{"op": "replace", "path": "/spec/type", "value": "LoadBalancer"}]'
