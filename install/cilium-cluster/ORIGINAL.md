https://docs.cilium.io/en/stable/gettingstarted/hubble_setup/#hubble-setup



==============================================================================
CREATE CLUSTER

vim kind-cluster
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
- role: worker
networking:
  disableDefaultCNI: true


cilium install --version 1.15.5
cilium status --wait


==============================================================================
INSTALL STAR WARS DEMO
https://docs.cilium.io/en/stable/gettingstarted/demo/




==============================================================================
HUBBLE


https://docs.cilium.io/en/stable/gettingstarted/demo/

kubectl create -f https://raw.githubusercontent.com/cilium/cilium/1.15.5/examples/minikube/http-sw-app.yaml

---
apiVersion: v1
kind: Service
metadata:
  name: deathstar
  labels:
    app.kubernetes.io/name: deathstar
spec:
  type: ClusterIP
  ports:
  - port: 80
  selector:
    org: empire
    class: deathstar
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deathstar
  labels:
    app.kubernetes.io/name: deathstar
spec:
  replicas: 2
  selector:
    matchLabels:
      org: empire
      class: deathstar
  template:
    metadata:
      labels:
        org: empire
        class: deathstar
        app.kubernetes.io/name: deathstar
    spec:
      containers:
      - name: deathstar
        image: quay.io/cilium/starwars:v2.1@sha256:833d915ec68fca3ce83668fc5dae97c455b2134d8f23ef96586f55b894cfb1e8
---
apiVersion: v1
kind: Pod
metadata:
  name: tiefighter
  labels:
    org: empire
    class: tiefighter
    app.kubernetes.io/name: tiefighter
spec:
  containers:
  - name: spaceship
    image: quay.io/cilium/json-mock:v1.3.8@sha256:5aad04835eda9025fe4561ad31be77fd55309af8158ca8663a72f6abb78c2603
---
apiVersion: v1
kind: Pod
metadata:
  name: xwing
  labels:
    app.kubernetes.io/name: xwing
    org: alliance
    class: xwing
spec:
  containers:
  - name: spaceship
    image: quay.io/cilium/json-mock:v1.3.8@sha256:5aad04835eda9025fe4561ad31be77fd55309af8158ca8663a72f6abb78c2603

=====================================================================
Install cilium CLI
cilium install
cilium status --wait
kubectl get cep -A

# should succeed
kubectl exec tiefighter -- \
  curl -s -XPOST deathstar.default.svc.cluster.local/v1/request-landing

# should fail but does not (need to config cilium)
kubectl exec xwing -- \
  curl -s -XPOST deathstar.default.svc.cluster.local/v1/request-landing

kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/HEAD/examples/minikube/sw_l3_l4_policy.yaml
ciliumnetworkpolicy.cilium.io/rule1 created

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

$ kubectl exec tiefighter -- \
  curl -s -XPOST deathstar.default.svc.cluster.local/v1/request-landing
Ship landed

$ kubectl exec xwing -- \
  curl -s -XPOST deathstar.default.svc.cluster.local/v1/request-landing
^C
hangs

kubectl exec tiefighter -- \
  curl -s -XPUT deathstar.default.svc.cluster.local/v1/exhaust-port
Panic: deathstar exploded

goroutine 1 [running]:
main.HandleGarbage(0x2080c3f50, 0x2, 0x4, 0x425c0, 0x5, 0xa)
        /code/src/github.com/empire/deathstar/
        temp/main.go:9 +0x64
main.main()
        /code/src/github.com/empire/deathstar/
        temp/main.go:5 +0x85

apiVersion: "cilium.io/v2"
kind: CiliumNetworkPolicy
metadata:
  name: "rule1"
spec:
  description: "L7 policy to restrict access to specific HTTP call"
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
      rules:
        http:
        - method: "POST"
          path: "/v1/request-landing"

# kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/HEAD/examples/minikube/sw_l3_l4_l7_policy.yaml
ciliumnetworkpolicy.cilium.io/rule1 configured

# kubectl exec tiefighter -- curl -s -XPUT deathstar.default.svc.cluster.local/v1/exhaust-port
Access denied


