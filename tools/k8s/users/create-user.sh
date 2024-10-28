#!/usr/bin/env bash

#set -x

KUSER=pjs
ROLE=readonlyuser

##############################################################################
echo
echo rm -f *.{crt,key,csr}
rm -f *.{crt,key,csr}

# generate private key
echo
openssl genrsa -out ${KUSER}.key 2048

# create a cert signing req
echo
openssl req -new -key ${KUSER}.key -out ${KUSER}.csr -subj "/CN=pauljsolomon.net/O=paulco"

# sign the cert with a cert authority
# to create a self-signed ca with openssl:
echo
openssl genrsa -out ca.key 2048
openssl req -new -x509 -key ca.key -out ca.crt -days 3650 -subj "/CN=pauljsolomon-net"

# with the CA certificate and key in hand, you can now sign the user’s CSR to generate a digital certificate.
# to do this, run the following command:
echo
openssl x509 -req -in ${KUSER}.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out ${KUSER}.crt

# copy creds to ~/.kube/config
echo
cp ${KUSER}.* ~/.kube


##############################################################################
# create service account
echo
kubectl create serviceaccount ${ROLE}
sleep 2

echo
kubectl apply -f secret.yaml
sleep 2

# kubectl create role ${ROLE} --verb=get --verb=list --verb=watch --resource=pods,services,daemonsets,deployments,cronjobs,horizontalpodautoscalers,replicasets,replicationcontrollers,statefulsets,jobs
echo
#kubectl apply -f role.yaml
kubectl create role ${ROLE} --verb=get --verb=list --verb=watch --resource=pods,services,daemonsets,deployments,cronjobs,horizontalpodautoscalers,replicasets,replicationcontrollers,statefulsets,jobs

# create rolebinding
# kubectl create rolebinding ${ROLE} --serviceaccount=default:${ROLE} --role=${ROLE}
echo
#kubectl apply -f rbinding.yaml
kubectl create rolebinding ${ROLE} --serviceaccount=default:${ROLE} --role=${ROLE}


##############################################################################
# set up ~.kube/config
# get the token from the created secret
TOKEN=$(kubectl describe secrets "$(kubectl describe serviceaccount ${ROLE} | grep -i Tokens | awk '{print $2}')" | grep token: | awk '{print $2}')

echo
kubectl config set-credentials ${KUSER} --client-certificate="/home/ansible/.kube/${KUSER}.crt" --client-key="/home/ansible/.kube/${KUSER}.key" --token=${TOKEN}
kubectl config set-context ${KUSER} --cluster=kind-main --namespace=default --user=${KUSER}


##############################################################################
echo
cat <<EOF
  kubectl config use-context ${KUSER}

  kubectl auth can-i get pods --all-namespaces  # yes
  kubectl auth can-i get pods -n kubectl  # yes
  kubectl auth can-i get secrets  # no
  kubectl auth can-i create pods  # no
  kubectl auth can-i delete pods  # no

  kubectl get all # succeeds
  kubectl run nginx --image=nginx  # fails
  kubectl get secrets  # fails

  kubectl config use-context kind-main
EOF

echo
