#!/usr/bin/env bash

NS=vault
UNSEAL_FILE=unseal-keys.txt

echo
echo unsealing vault

i=0
grep "Unseal Key" ${UNSEAL_FILE} | cut -d':' -f2 | sed 's/^ //' | while read -r LINE
do
  i=$(expr $i + 1)
  [[ $i == 4 ]] && break

  echo
  echo "==================== Unsealing key ${i} ===================="
  # see: https://github.com/hashicorp/vault/issues/3869
  # to see the hidden characters:  echo ${LINE} | cat -v

  LINE0=$(echo ${LINE} | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g')
  echo "kubectl -n ${NS} exec vault-0 -- vault operator unseal ***********"
  kubectl -n ${NS} exec vault-0 -- vault operator unseal "${LINE0}"
done

# TODO: kubectl wait does not work to check for Running state
./wait-for-vault-available.sh vault vault-0 Ready

echo
kubectl get all -n vault

echo
echo waiting for vault before creating clustersecretstore
sleep 25

echo
echo creating secret store
echo kubectl apply -f secretstore.yaml
kubectl apply -f secretstore.yaml

./status.sh
