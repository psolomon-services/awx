Example of pulling docker (or using existing) then pushing into kind cluster (nodes)

docker pull bitnami/redis:7.0.11-debian-11-r12
kind load docker-image -n dev bitnami/redis:7.0.11-debian-11-r12

CA ISSUER/SELF-SIGNED CERTS VIA K8S
https://medium.com/geekculture/a-simple-ca-setup-with-kubernetes-cert-manager-bc8ccbd9c2

# get password
kubectl get secret -n jenkins jenkins -o=jsonpath='{.data.jenkins-admin-password}' | base64 -d; echo

$ kubectl get secret -n jenkins jenkins-server-tls -o=jsonpath='{.data.ca\.crt}' | base64 -d; echo
-----BEGIN CERTIFICATE-----
MIIDVTCCAj2gAwIBAgIRAOmbRB3L6wN7icAfN3xTKrkwDQYJKoZIhvcNAQELBQAw
RDEhMB8GA1UEChMYUGF1bGNvIEFXWCBTZXJ2ZXIgSXNzdWVyMQ0wCwYDVQQLEwRB
V1gxMRAwDgYDVQQDEwd0ZXN0LWNhMB4XDTI0MDcxMTE4Mjg0MVoXDTI0MTAwOTE4
Mjg0MVowRDEhMB8GA1UEChMYUGF1bGNvIEFXWCBTZXJ2ZXIgSXNzdWVyMQ0wCwYD
VQQLEwRBV1gxMRAwDgYDVQQDEwd0ZXN0LWNhMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEA4Mtbnlj0RaldvuvvP7cxyDbEcHcUg36EBJ2HhhWJXU0Phnhv
uKjp33yM42zqu0107m4utX2Ip/weQfQVHhIIMQhvuGMGOBPOak1xAYoJjkiuFzdK
HleEHtje+1jKKrwOyX6RUoZfB+bCj+bMznbpK5c2tfPcbjmRWVpvyrGSXjDtSRPh
zVCrfI9XgECghe6OFiDTlows5Nl13g2llbvl3v5XdMQt4RX7ihMjY6zBZSi/2Y31
UYuZb8B5fh8rs+LjMm+LhurQGlVULpZXaed4UN+y5RT3iJJgqlqZt9oV+4CF1UK9
f2VfkanP9GD4W2WReBi26JSXtgQiI768MR6a5QIDAQABo0IwQDAOBgNVHQ8BAf8E
BAMCAqQwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQU73gq9nZRIdTrQ3299MAq
j5G5IhUwDQYJKoZIhvcNAQELBQADggEBAM03R85B9v4T6E59q2PulpuHU5Q77jQQ
AEnm41dmHXxm+SAj8kA6o8sUkiqNFNyWXExtkQ9+aM6AGJvBpXur5Y2T9bh/R4fd
/9I1/BkUhWWDAdyOQtAZscWi0OAzBqSJ6YD5qGBms4z1sH6kcJc466ExDnf5F7In
mf2i8qnO8fJF9vT4XqAvvNgYfTzxSWiGmSCJabBL7ERS5/mra5mgwYblsy9qYbXP
WLMDvYT6kK9ppAau7VSRab4XnijWgSF3WJx9MrDVYDUGhOWRjDOgReerIQ3PR9XN
0qoR+7P5igsaxZeZzeAk1hrkG6VTEKdUdSgllfwxFE03FdYpTVUiCDg=
-----END CERTIFICATE-----

