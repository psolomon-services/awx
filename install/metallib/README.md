Installation

https://metallb.universe.tf/installation/

helm repo add metallb https://metallb.github.io/metallb
helm install metallb metallb/metallb

#helm install -n metallb-system --create-namespace metallb metallb/metallb -f values.yaml
helm install -n metallb-system --create-namespace metallb metallb/metallb

# https://metallb.universe.tf/installation/
kubectl edit configmap -n kube-system kube-proxy

