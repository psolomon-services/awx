#!/usr/bin/env bash

ROLE=readonlyuser

kubectl delete serviceaccount ${ROLE}
kubectl delete secret ${ROLE}
kubectl delete rolebinding ${ROLE}
kubectl delete role ${ROLE}

