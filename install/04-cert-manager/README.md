# https://cert-manager.io/docs/installation/helm/

# install cmctl

https://cert-manager.io/docs/reference/cmctl/#installation

```
OS=$(go env GOOS); ARCH=$(go env GOARCH); curl -fsSL -o cmctl https://github.com/cert-manager/cmctl/releases/latest/download/cmctl_${OS}_${ARCH}
chmod +x cmctl
sudo mv cmctl /usr/local/bin
```

# verify cert-manager

`$ cmctl check api`
The cert-manager API is ready

# Extract CA, cert, key
#kubectl get secret -n ingress-test myingress-cert -o json | jq -r  '.data["ca.crt"]' | base64 -d > ca.crt
#kubectl get secret -n ingress-test myingress-cert -o json | jq -r  '.data["tls.crt"]' | base64 -d > tls.crt
#kubectl get secret -n ingress-test myingress-cert -o json | jq -r  '.data["tls.key"]' | base64 -d > tls.key

# Extract cluster issuer CA
kubectl get secrets -n cert-manager test-ca -o json | jq -r '.data["tls.crt"]' | base64 -d > issuer.crt

diff issuer.crt ca.crt && echo "Issuing CA matches Ingress CA" || echo "Issuing CA doesn't match Ingress CA"

openssl verify -CAfile issuer.crt tls.crt

rm ./*.crt ./*.key
