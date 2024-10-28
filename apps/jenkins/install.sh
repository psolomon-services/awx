#!/usr/bin/env bash

DIR=/data/jenkins
NS=jenkins

for i in "" 2 3
do
  WORKER=main-worker${i}
  echo docker exec ${WORKER} mkdir -p ${DIR}
  docker exec ${WORKER} mkdir -p ${DIR}

  #docker cp ~/repos/argocd-test/ansible/playbooks/roles/jenkins/templates/plugins.txt ${WORKER}:${DIR}
done

echo kubectl create ns ${NS}
kubectl create ns ${NS}

echo kubectl delete configmap -n ${NS} jenkins-casc
kubectl delete configmap -n ${NS} jenkins-casc

kubectl create configmap -n ${NS} jenkins-casc --from-file=casc.yaml=casc.yaml.txt

echo kubectl apply -f jenkins-proj.yaml,jenkins-app.yaml
kubectl apply -f jenkins-proj.yaml,jenkins-app.yaml

watch kubectl get all -n ${NS}
