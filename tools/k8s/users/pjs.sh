#!/usr/bin/env bash

echo
cat <<EOF
  kubectl config use-context ${USER}

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
