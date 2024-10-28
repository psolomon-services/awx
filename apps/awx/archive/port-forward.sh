#!/usr/bin/env bash

echo
echo port forward for AWX
#kubectl port-forward svc/awx-demo-service --address 0.0.0.0 -n awx 8081:80
nohup kubectl port-forward svc/awx-demo-service --address 0.0.0.0 -n awx 8081:80 2> /dev/null &
