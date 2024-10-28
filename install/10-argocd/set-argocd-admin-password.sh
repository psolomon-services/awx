#!/usr/bin/env bash

#  -p '{"stringData": {
#    "admin.password": "$(argocd account bcrypt --password mywebpassword)",
#    "admin.passwordMtime": "'$(date +%FT%T%Z)'"

JSON=$(cat <<EOF
{"stringData": {
    "admin.password":      "$(argocd account bcrypt --password mywebpassword)",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }
}
EOF
)

# bcrypt(password)=$2a$10$rRyBsGSHK6.uc8fntPwVIuLVHgsAhAX7TcdrqW/RADU0uh7CaChLa
echo kubectl -n argocd patch secret argocd-secret -p "${JSON}"
kubectl -n argocd patch secret argocd-secret -p "${JSON}"
