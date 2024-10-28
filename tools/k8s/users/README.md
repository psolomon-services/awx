# Adding a user

* See:  https://collabnix.com/how-to-create-user-in-kubernetes-cluster-and-give-it-access/

* Steps:

  ```
  ###########################################################################
  # generate private key
  openssl genrsa -out pjs.key 2048

  # create a cert signing req
  openssl req -new -key pjs.key -out pjs.csr -subj "/CN=pauljsolomon.net/O=paulco"

  # sign the cert with a cert authority
  # to create a self-signed ca with openssl:
  openssl genrsa -out ca.key 2048
  openssl req -new -x509 -key ca.key -out ca.crt -days 3650 -subj "/CN=pauljsolomon-net"

  # with the CA certificate and key in hand, you can now sign the user’s CSR to generate a digital certificate.
  # to do this, run the following command:
  openssl x509 -req -in pjs.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out pjs.crt

  # copy creds to ~/.kube/config
  cp pjs.* ~/.kube


  ###########################################################################
  # create service account
  kubectl create serviceaccount readonlyuser

  # create secret
  vim secret.yaml

  apiVersion: v1
  kind: Secret
  metadata:
    name: readonlyuser
    annotations:
      kubernetes.io/service-account.name: readonlyuser
  type: kubernetes.io/service-account-token

  # token should be added


  ###########################################################################
  # create clusterrole
  vim crole.yaml
  ---
  # kubectl create clusterrole readonlyuser --verb=get --verb=list --verb=watch --resource=pods,services,daemonsets,deployments,cronjobs,horizontalpodautoscalers,replicasets,replicationcontrollers,statefulsets,jobs

  apiVersion: rbac.authorization.k8s.io/v1
  kind: ClusterRole
  metadata:
    name: readonlyuser
  rules:
    - apiGroups: ['']
      resources: [
        "pods",
        "pods/log",
        "replicationcontrollers",
        "services",
      ]
      verbs: ['get', 'watch', 'list']

    - apiGroups: ['apps']
      resources: [
        "daemonsets",
        "deployments",
        "replicasets",
        "statefulsets",
      ]
      verbs: ['get', 'watch', 'list']

    - apiGroups: ['batch']
      resources: [
        "jobs",
        "cronjobs",
      ]
      verbs: ['get', 'watch', 'list']

    - apiGroups: ['autoscaling']
      resources: [
        "horizontalpodautoscalers",
      ]
      verbs: ['get', 'watch', 'list']


  ###########################################################################
  # create clusterrolebinding
  kubectl create clusterrolebinding readonlyuser --serviceaccount=default:readonlyuser --clusterrole=readonlyuser


  ###########################################################################
  # set up ~.kube/config
  # get the token from the created secret
  TOKEN=$(kubectl describe secrets "$(kubectl describe serviceaccount readonlyuser | grep -i Tokens | awk '{print $2}')" | grep token: | awk '{print $2}')

  kubectl config set-credentials pjs --client-certificate='/home/ansible/.kube/pjs.crt' --client-key='/home/ansible/.kube/pjs.key' --token=${TOKEN}
  kubectl config set-context pjs --cluster=kind-main --namespace=default --user=pjs

  # use the context
  kubectl config use-context pjs


  ###########################################################################
  # check access

  kubectl auth can-i get pods --all-namespaces  # no
  kubectl auth can-i get pods -n kubectl  # no
  kubectl auth can-i get secrets  # no
  kubectl auth can-i create pods  # no
  kubectl auth can-i delete pods  # no

  kubectl get all # succeeds
  kubectl run nginx --image=nginx  # fails
  kubectl get secrets  # fails

  kubectl config use-context kind-main
  ```
