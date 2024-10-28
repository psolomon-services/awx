# MISC NOTES

# https://github.com/prometheus-operator/kube-prometheus
# LOCATION: https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml
#  and for overriding the subchart grafana:
# LOCATION:  https://github.com/grafana/helm-charts/blob/main/charts/grafana/values.yaml

#kubectl apply --server-side -f manifests/setup
#kubectl wait \
#	--for condition=Established \
#	--all CustomResourceDefinition \
#	--namespace=monitoring
#kubectl apply -f manifests/
# teardown:  kubectl delete --ignore-not-found=true -f manifests/ -f manifests/setup

helm repo add bitnami https://charts.bitnami.com/bitnami

helm install my-kube-prometheus bitnami/kube-prometheus --version 9.5.7

##echo
##echo helm repo add bitnami https://charts.bitnami.com/bitnami
##helm repo add bitnami https://charts.bitnami.com/bitnami

##echo
##echo helm install my-kube-prometheus bitnami/kube-prometheus --version 9.5.7 -f values.txt
##helm install -n monitoring grafana bitnami/kube-prometheus --version 9.5.7 -f values.txt --create-namespace
