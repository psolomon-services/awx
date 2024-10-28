#/usr/bin/env bash

NS=awx
SLEEP=20
DEPLOY=awx-demo-task

cd /root/argocd-test

echo
echo "Ansible AWX Build Script"
echo "  AWX_BUILDER_VERSION: >${AWX_BUILDER_VERSION}<"

echo
echo
echo waiting for ${NS}:${DEPLOY} to be available
./wait-for-deploy-available.sh ${NS} ${DEPLOY} ${SLEEP}

echo
echo deploying awx
echo ansible-playbook ansible/playbooks/awx.yml --vault-password-file .vault-password
ansible-playbook ansible/playbooks/awx.yml --vault-password-file .vault-password
echo
