#!/usr/bin/env bash

# https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-amazon-eks

CLUSTER=learn-vault
NS=vault
NODES=2
KEYPAIR=pjs-keypair

# https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-amazon-eks


echo
echo creating cluster ${CLUSTER}
eksctl create cluster \
    --name ${CLUSTER} \
    --nodes ${NODES} \
    --with-oidc \
    --ssh-access \
    --ssh-public-key ${KEYPAIR} \
    --managed

eksctl create iamserviceaccount \
    --name ebs-csi-controller-sa \
    --namespace kube-system \
    --cluster ${CLUSTER} \
    --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
    --approve \
    --role-only \
    --role-name AmazonEKS_EBS_CSI_DriverRole

eksctl create addon \
    --name aws-ebs-csi-driver \
    --cluster ${CLUSTER} \
    --service-account-role-arn arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):role/AmazonEKS_EBS_CSI_DriverRole

kubectl create ns ${NS}


###############################################################################

cat > helm-vault-raft-values.yml <<EOF
server:
   affinity: ""
   ha:
      enabled: true
      raft:
         enabled: true
         setNodeId: true
         config: |
            cluster_name = "vault-integrated-storage"
            storage "raft" {
               path    = "/vault/data/"
            }

            listener "tcp" {
               address = "[::]:8200"
               cluster_address = "[::]:8201"
               tls_disable = "true"
            }
            service_registration "kubernetes" {}
EOF


helm install vault hashicorp/vault --values helm-vault-raft-values.yml -n ${NS} --create-namespace


# TEMP:  edit vault pvcs (1-3) and add StorageClassName: gp2  (indent one under spec:)

for i in 1 2 3
do
  kubectl edit pvc -n vault data-vault-${i}
done


###############################################################################


kubectl exec -n ${NS} vault-0 -- vault operator init \
    -key-shares=1 \
    -key-threshold=1 \
    -format=json | tee cluster-keys.json

VAULT_UNSEAL_KEY=$(cat cluster-keys.json | jq -r ".unseal_keys_b64[]")

kubectl exec -n ${NS} vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY


CLUSTER_ROOT_TOKEN=$(cat cluster-keys.json | jq -r ".root_token")

kubectl exec -n ${NS} vault-0 -- vault login $CLUSTER_ROOT_TOKEN

kubectl exec -n ${NS} vault-0 -- vault operator raft list-peers
Node       Address                        State     Voter
----       -------                        -----     -----
vault-0    vault-0.vault-internal:8201    leader    true


for i in 1 2
do
  kubectl exec -n ${NS} vault-${i} -- vault operator raft join http://vault-0.vault-internal:8200

  kubectl exec -n ${NS} vault-${i} -- vault operator unseal $VAULT_UNSEAL_KEY
done


###############################################################################

# https://external-secrets.io/v0.4.3/guides-getting-started/

NS2=external-secrets

echo
echo installing external secrets into namespace ${NS2}

helm repo add external-secrets https://charts.external-secrets.io

helm install external-secrets external-secrets/external-secrets -n ${NS2} --create-namespace --set installCRDs=true


###############################################################################
# create the vault secret
kubectl exec -n vault -it vault-0 -- vault kv put cubbyhole/pjs mysecret=wow


###############################################################################

CLUSTER_ROOT_TOKEN=$(cat cluster-keys.json | jq -r ".root_token")

kubectl delete secret vault-token # -n ${NS}

kubectl create secret generic vault-token --from-literal=token=${CLUSTER_ROOT_TOKEN} #-n ${NS}

# create vault secret store
kubectl apply -f secretstore.yaml

# create external secret
kubectl apply -f externalsecret.yaml


###############################################################################

