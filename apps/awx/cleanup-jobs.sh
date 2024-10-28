#!/usr/bin/env bash

JOB=awx-ansible-deploy

echo
echo cleaning up awx job
echo kubectl delete -n awx job ${JOB}
kubectl delete -n awx job ${JOB}

echo
kubectl get all -n awx
echo
