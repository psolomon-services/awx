# https://dzone.com/articles/deploying-prometheus-and-grafana-as-applications-u

# reset password
# https://community.grafana.com/t/admin-password-reset/19455/9
# grafana-cli admin reset-admin-password mynewpassword


helm upgrade prometheus prometheus-community/kube-prometheus-stack -n monitoring --create-namespace -f values.txt

kubectl describe ing -n monitoring prometheus-grafana
