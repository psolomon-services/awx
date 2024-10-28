
https://kubernetes-sigs.github.io/metrics-server/

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

kubectl get deployments metrics-server -n kube-system


- Kubelet certificate needs to be signed by cluster Certificate Authority (or disable certificate validation by passing `--kubelet-insecure-tls` to Metrics Server)

$ kubectl top pod -A
NAMESPACE            NAME                                         CPU(cores)   MEMORY(bytes)
kube-system          coredns-76f75df574-g84wt                     2m           13Mi
kube-system          coredns-76f75df574-wgwsc                     2m           12Mi
kube-system          etcd-main-control-plane                      27m          33Mi
kube-system          kindnet-9j69t                                1m           7Mi
kube-system          kindnet-cr9xx                                1m           8Mi
kube-system          kindnet-lq6vl                                1m           8Mi
kube-system          kindnet-w7j6g                                1m           7Mi
kube-system          kube-apiserver-main-control-plane            63m          203Mi
kube-system          kube-controller-manager-main-control-plane   18m          40Mi
kube-system          kube-proxy-btx2t                             1m           11Mi
kube-system          kube-proxy-bvchw                             1m           11Mi
kube-system          kube-proxy-hf64k                             1m           11Mi
kube-system          kube-proxy-r5j9q                             1m           11Mi
kube-system          kube-scheduler-main-control-plane            4m           17Mi
kube-system          metrics-server-84989b68d9-ldblj              4m           15Mi
local-path-storage   local-path-provisioner-7577fdbbfb-r8dr8      1m           7Mi

kubectl -n kube-system edit pod metrics-server-84989b68d9-ldblj
