#!/usr/bin/env bash

echo
echo container list for this cluster
kubectl get pods --all-namespaces -o jsonpath="{.items[*].spec['initContainers', 'containers'][*].image}" |tr -s '[[:space:]]' '\n' |sort |uniq -c
