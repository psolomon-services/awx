#!/usr/bin/env bash

#echo kubectl apply -f ansible-pod.yaml
#kubectl apply -f ansible-pod.yaml
#
#echo sleep 5
#sleep 5
#
#kubectl exec -it ansible -- bash -c "cd /root/argocd-test; ansible-playbook ansible/playbooks/ping.yml"

echo
echo cleaning up awx job
echo kubectl delete -n awx job.batch/awx-ansible-deploy
kubectl delete -n awx job.batch/awx-ansible-deploy
