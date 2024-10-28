# https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-raft-deployment-guide

# https://craftech.io/blog/manage-your-kubernetes-secrets-with-hashicorp-vault/

$ kubectl -n vault exec -ti vault-0 -- vault operator init

Unseal Key 1: MMtEQtOLgsLvH4F25Sweu6hl8oWaP3t/tw/WfxT4RvQM
Unseal Key 2: lKg2cnQfiuFTsyOZJIVaLYFJC7ugOuJJn5SB6tBRZLhd
Unseal Key 3: yY2+3WKwa58Kle7TQ73P7GM1J5YV8g8aM1yN+1Ym1IMC
Unseal Key 4: Knzc0KAlH1GXyqMMsnOdm1JtNZLzFL44d4fiviYhl2wx
Unseal Key 5: /65ONZgxRdyGAOFEkZBCHrSW1Dkfzt7xGY+HigNfpnTG

Initial Root Token: hvs.iT46bXpk9ehIOoPr86jb5HtT

Vault initialized with 5 key shares and a key threshold of 3. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 3 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated root key. Without at least 3 keys to
reconstruct the root key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.


$ kubectl -n vault exec -ti vault-0 -- vault operator unseal
Unseal Key (will be hidden):

(repeat 2 more times for a total of 3 unsealings)


pjs.hcl

path "*"
 {  capabilities = ["read"]
 }


vault policy write -tls-skip-verify external-secrets-policy pjs.hcl


readiness probe fails:
https://github.com/helm/charts/issues/24471
