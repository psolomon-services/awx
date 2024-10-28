# USE ARGOCD WITH GITHUB TOKENS
# https://www.redhat.com/en/blog/how-to-use-argocd-deployments-with-github-tokens

Create the secret and argocd will automatically add that repo

# create self-signed cert
openssl req -x509 \
            -newkey rsa:4096 \
            -sha256 \
            -nodes \
            -keyout argocd-server-tls.key \
            -out argocd-server-tls.crt \
            -subj "/CN=argocd.pauljsolomon.net/O=pauljsolomon.net/OU=pauljsolomon.net" \
            -days 365

# check attributes
openssl x509 -in argocd-server-tls.crt -text -noout


