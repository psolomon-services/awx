#!/usr/bin/env bash

DIRLIST="dnsmasq.d etc"
NS=pihole

 for i in "" 2 3
 do
   echo "main-worker${i}";
   WORKER=main-worker${i}
   for DIR in $DIRLIST
   do
     echo ${i}: docker exec ${WORKER} mkdir -p /data/pihole/$DIR
     docker exec ${WORKER} mkdir -p /data/pihole/$DIR
     docker exec ${WORKER} ls -al /data/pihole
   done
 done

echo
echo installing pihole in argocd
kubectl apply -f pihole-proj.yaml,pihole-app.yaml

watch kubectl get all -n ${NS}
echo
