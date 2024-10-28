
# https://prefetch.net/blog/2022/04/08/ways-to-debug-kubernetes-pods-without-shells/

kubectl debug -n kube-system -it coredns-64897985d-tn4tb --target=coredns --image=ubuntu
