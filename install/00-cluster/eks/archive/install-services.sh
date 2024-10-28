#!/usr/bin/env bash

#$ for i in first second third fourth error; do echo ; curl -H "Host: $i.pauljsolomon.net" apps-ingress-2031651306.us-east-1.elb.amazonaws.com/; done
#first
#second
#third
#fourth
#error

NS=apps

for SERVICE_NAME0 in first second third fourth error; do
  echo "SERVICE_NAME=$SERVICE_NAME0 NS=${NS} envsubst < service.yml | kubectl apply -f -"
  SERVICE_NAME=${SERVICE_NAME0} NS=${NS} envsubst < service.yml | kubectl apply -f -
done
