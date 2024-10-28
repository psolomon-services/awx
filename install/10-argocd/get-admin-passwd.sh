echo
echo initial admin login
#kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo;
#kubectl -n argocd get secret argocd-secret -o jsonpath="{.data.admin.password}" | base64 -d; echo;
kubectl -n argocd get secret argocd-secret -o jsonpath="{.data.admin\.password}" | base64 -d; echo;
echo
echo
