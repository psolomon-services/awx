#!/usr/bin/env bash

#CLUSTER=argocd
CLUSTER=learn-vault
ACCOUNT=913076961925

#eksctl create cluster --profile mgmt -N 3 --name ${CLUSTER}

#eksctl utils update-cluster-logging --enable-types=all --region=us-east-1 --cluster=${CLUSTER} --approve

# remove cw logs:
##eksctl utils update-cluster-logging --disable-types=all --region=us-east-1 --cluster=${CLUSTER} --approve

#curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.2/docs/install/iam_policy.json
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json

eksctl utils associate-iam-oidc-provider --cluster $CLUSTER --approve

eksctl delete iamserviceaccount --name=aws-load-balancer-controller --namespace=kube-system --cluster=${CLUSTER}

eksctl create iamserviceaccount \
  --cluster=${CLUSTER} \
  --name=aws-load-balancer-controller \
  --namespace=kube-system \
  --attach-policy-arn=arn:aws:iam::${ACCOUNT}:policy/AWSLoadBalancerControllerIAMPolicy \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --override-existing-serviceaccounts \
  --approve

helm repo add eks https://aws.github.io/eks-charts
helm repo update eks
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=${CLUSTER} \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
