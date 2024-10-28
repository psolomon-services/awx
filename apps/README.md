##############################################################################
INSTALL ARGOCD VIA HELM
https://blog.fourninecloud.com/installing-argo-cd-using-helm-ed4a0cd0845a

helm repo add argo https://argoproj.github.io/argo-helm
helm show values -n argocd argo/argo-cd > values-repo.yaml

$ cat values.txt
configs:
  cm:
    # -- Timeout to discover if a new manifests version got published to the repository
    #timeout.reconciliation: 180s
    timeout.reconciliation: 5s

    # -- Timeout to refresh application data as well as target manifests cache
    #timeout.hard.reconciliation: 0s
    timeout.hard.reconciliation: 5s

helm install -n argocd --create-namespace argocd argo/argo-cd -f values.txt
  (helm delete -n argocd argocd)

  (to upgrade:  helm upgrade -n argocd argocd argo/argo-cd -f values.txt)

(You should delete the initial secret afterwards as suggested by the Getting Started Guide: https://argo-cd.readthedocs.io/en/stable/getting_started/#4-login-using-the-cli)

##############################################################################

$ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
  or
$ kubectl view-secret -n argocd argocd-initial-admin-secret; echo

Choosing key: password
ydDDfz5vb8waX0iB

argocd login localhost:8083

##############################################################################
Create proj and app:

kubectl apply -f .

$ helm get values -n argocd argocd
USER-SUPPLIED VALUES:
configs:
  cm:
    timeout.hard.reconciliation: 5s
    timeout.reconciliation: 5s


##############################################################################
(Optional) Add private repos:

$ argocd repo add git@github.com:psolomon-services/ansible-pihole.git --ssh-private-key-path ~/.ssh/id_rsa
Repository 'git@github.com:psolomon-services/ansible-pihole.git' added
