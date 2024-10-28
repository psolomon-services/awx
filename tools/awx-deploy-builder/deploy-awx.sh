#/usr/bin/env bash

NS=awx
SLEEP=10
JOB=awx-demo-migration-24.6.0

cd /root/argocd-test

echo
echo "waiting (a LONG time) for awx-demo-task deployment to become available (meaning the migration is done)"
kubectl wait --for=condition=Available -n awx deploy awx-demo-task --timeout=3600s

#echo
#echo ./wait-for-job-completion.sh ${NS} ${JOB}
#./wait-for-job-completion.sh ${NS} ${JOB}

./create-certs-and-secret.sh

echo
echo "waiting a precautionary ${SLEEP} seconds before running awx playbook"
sleep ${SLEEP}

echo
echo deploying awx
echo ansible-playbook ansible/playbooks/awx.yml --vault-password-file .vault-password
ansible-playbook ansible/playbooks/awx.yml --vault-password-file .vault-password
echo
