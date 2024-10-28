##############################################################################
INSTALL ARGOCD VIA HELM
https://blog.fourninecloud.com/installing-argo-cd-using-helm-ed4a0cd0845a

helm repo add argo https://argoproj.github.io/argo-helm
helm show values -n argocd argo/argo-cd > values-repo.yaml

vim values.yaml
crds:
  # -- Install and upgrade CRDs problems if
  install: false

helm install -n argocd --create-namespace argocd argo/argo-cd -f values.yaml

NAME: argocd
LAST DEPLOYED: Tue May 14 16:50:36 2024
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
In order to access the server UI you have the following options:

1. kubectl port-forward service/argocd-server -n default 8080:443

    and then open the browser on http://localhost:8080 and accept the certificate

2. enable ingress in the values file `server.ingress.enabled` and either
      - Add the annotation for ssl passthrough: https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#option-1-ssl-passthrough
      - Set the `configs.params."server.insecure"` in the values file and terminate SSL at your ingress: https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#option-2-multiple-ingress-objects-and-hosts


After reaching the UI the first time you can login with username: admin and the random password generated during the installation. You can find the password by running:

kubectl -n default get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

(You should delete the initial secret afterwards as suggested by the Getting Started Guide: https://argo-cd.readthedocs.io/en/stable/getting_started/#4-login-using-the-cli)


##############################################################################
$ kubectl view-secret -n argocd argocd-initial-admin-secret; echo
Choosing key: password
ydDDfz5vb8waX0iB

argocd login localhost:8083


##############################################################################
argocd private repos

$ argocd repo add git@github.com:psolomon-services/ansible-pihole.git --ssh-private-key-path ~/.ssh/id_rsa


##############################################################################
Create proj:

kind: AppProject
apiVersion: argoproj.io/v1alpha1
metadata:
  name: dev-project
  namespace: argocd
spec:
  description: Dev Project
  sourceRepos:
    - '*'

  destinations:
  - namespace: ns-1
    server:    https://kubernetes.default.svc

  clusterResourceWhitelist:
  - group: '*'
    kind:  '*'

  namespaceResourceWhitelist:
  - group: '*'
    kind:  '*'

  roles:
  - name: ci-role
    description: "Sync privs for dev-project"
    policies:
    - p, proj:dev-project:ci-role, applications, sync, dev-project/*, allow
    - p, proj:dev-project:ci-role, applications, get,  dev-project/*, allow

kubectl apply -f dev-proj.yaml


##############################################################################
create token, not needed for now

$ argocd proj role create-token dev-project ci-role
Create token succeeded for proj:dev-project:ci-role.
  ID: eae197f9-487b-4250-8ca8-2d8c24e159e3
  Issued At: 2024-05-14T17:40:54-05:00
  Expires At: Never
  Token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhcmdvY2QiLCJzdWIiOiJwcm9qOmRldi1wcm9qZWN0OmNpLXJvbGUiLCJuYmYiOjE3MTU3MjY0NTQsImlhdCI6MTcxNTcyNjQ1NCwianRpIjoiZWFlMTk3ZjktNDg3Yi00MjUwLThjYTgtMmQ4YzI0ZTE1OWUzIn0.muoFH_jg4E4hflFL0bRJ5B1d8fdiTCwDtTT-K1gFjFQ


##############################################################################
Create app:

kind: Application
apiVersion: argoproj.io/v1alpha1
metadata:
  name: guestbook-dev-project
  namespace: argocd
spec:
  destination:
    namespace: ns-1
    server: "https://kubernetes.default.svc"
  project: dev-project
  source:
    path: app/guestbook
    repoURL: git@github.com:psolomon-services/ansible-pihole.git
    targetRevision: main
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true

kubectl apply -f dev-app-git.yaml



##############################################################################
##############################################################################
##############################################################################
##############################################################################

# INSTALL ARGOCD MANUALLY

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8083:443
open browser https://localhost:8083/


##############################################################################
# REFERENCE
for class:  https://github.com/mabusaa/argocd-course-apps-definitions/blob/main/applications%20and%20projects/application.yaml

