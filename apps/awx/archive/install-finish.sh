#!/usr/bin/env bash

NS=awx
MIGRATION_JOB=awx-demo-migration-24.6.0
ANSIBLE_JOB=awx-ansible-deploy

echo
echo checking for existing job ${NS}:${ANSIBLE_JOB}
echo kubectl get -n ${NS} job ${ANSIBLE_JOB}
kubectl get -n ${NS} job ${ANSIBLE_JOB}
if [ $? -eq 0 ]; then
  echo
  echo "ERROR:  deploy job ${NS}:${ANSIBLE_JOB} already exists, delete it before running"
  echo "    (run:  ./cleanup-jobs.sh to remove the existing job)"
  echo
  exit 1
fi

./wait-for-job-completion.sh ${NS} ${MIGRATION_JOB}

echo
echo creating awx ansible deploy Job
echo kubectl apply -f deploy-awx-job.yaml
kubectl apply -f deploy-awx-job.yaml

echo
echo waiting for awx ansible deploy job to begin
sleep 5
stern -n awx ${ANSIBLE_JOB}
