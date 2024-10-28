# NOTES

To install the ArgoCD Project and Application for AWX:

* `kubectl apply -f .`

# port forward

* `kubectl port-forward --address 0.0.0.0 svc/awx-demo-service -n awx 32001:80`


# Kustomize

https://www.densify.com/kubernetes-tools/kustomize/

## Get YAML to examine:

* `kustomize build .`

# Helm

* TODO, maybe
* https://ansible.readthedocs.io/projects/awx-operator/en/latest/installation/helm-install-on-existing-cluster.html

ADD CREDS FOR PRIVATE REPO

* argocd repo add git@github.com:psolomon-services/argocd-test.git --ssh-private-key-path ~/.ssh/id_rsa

NFS MOUNT SETUP

* ubuntu
  * https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-20-04

* k8s
  * https://rudimartinsen.com/2022/01/05/nginx-nfs-kubernetes/


