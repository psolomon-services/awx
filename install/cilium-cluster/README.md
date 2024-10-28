https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/
==============================================================================
CREATE CLUSTER

vim kind-cluster.yaml

kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
- role: worker
networking:
  disableDefaultCNI: true    # <-- for cilium only

kind create cluster --config kind-cluster.yaml --name main

cilium install --version 1.15.5
cilium status --wait


==============================================================================
INSTALL STAR WARS DEMO
https://docs.cilium.io/en/stable/gettingstarted/demo/
kubectl create -f https://raw.githubusercontent.com/cilium/cilium/1.15.5/examples/minikube/http-sw-app.yaml


# test
$ kubectl exec xwing -- curl -s -XPOST deathstar.default.svc.cluster.local/v1/request-landing
Ship landed
$ kubectl exec tiefighter -- curl -s -XPOST deathstar.default.svc.cluster.local/v1/request-landing
Ship landed


apiVersion: "cilium.io/v2"
kind: CiliumNetworkPolicy
metadata:
  name: "rule1"
spec:
  description: "L3-L4 policy to restrict deathstar access to empire ships only"
  endpointSelector:
    matchLabels:
      org: empire
      class: deathstar
  ingress:
  - fromEndpoints:
    - matchLabels:
        org: empire
    toPorts:
    - ports:
      - port: "80"
        protocol: TCP


==============================================================================
# note, example on site didn't work
$ kubectl create -f https://raw.githubusercontent.com/cilium/cilium/1.15.5/examples/minikube/sw_l3_l4_policy.yaml

# retest
$ kubectl exec xwing -- curl -s -XPOST deathstar.default.svc.cluster.local/v1/request-landing
still hangs...
$ kubectl exec tiefighter -- curl -s -XPOST deathstar.default.svc.cluster.local/v1/request-landing
Ship landed


# kubectl exec tiefighter -- curl -s -XPUT deathstar.default.svc.cluster.local/v1/exhaust-port
Panic: deathstar exploded


==============================================================================
kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/1.15.5/examples/minikube/sw_l3_l4_l7_policy.yaml

kubectl exec tiefighter -- curl -s -XPUT deathstar.default.svc.cluster.local/v1/exhaust-port
Access denied


==============================================================================
pick a node get policy
kubectl -n kube-system exec cilium-465cn -- cilium-dbg policy get


==============================================================================
monitor
kubectl exec -it -n kube-system cilium-kzgdx -- cilium-dbg monitor -v --type l7

==============================================================================
ENABLE HUBBLE

https://docs.cilium.io/en/stable/gettingstarted/hubble_setup/#hubble-setup

cilium enable hubble


==============================================================================
CILIUM INGRESS

cilium config view | grep ingress-controller

In this lab's environment, Cilium has been installed using the cilium CLI and the following flags:
--set ingressController.enabled=true
