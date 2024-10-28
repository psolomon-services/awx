USER=admin; PASSWORD=mywebpassword; echo "${USER}:$(openssl passwd -stdin -apr1 <<< ${PASSWORD})" >> auth
cat auth
kubectl -n longhorn-system create secret generic basic-auth --from-file=auth
