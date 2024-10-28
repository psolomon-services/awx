#!/usr/bin/env bash

CLUSTER=argocd
ACCOUNT=913076961925

OIDC_ID=$(aws eks describe-cluster --name ${CLUSTER} --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)
echo OIDC_ID: $OIDC_ID

#aws iam list-open-id-connect-providers | grep $OIDC_ID | cut -d "/" -f4
#returns nothing

echo
echo creating OIDC provider
echo eksctl utils associate-iam-oidc-provider --cluster ${CLUSTER} --approve
eksctl utils associate-iam-oidc-provider --cluster ${CLUSTER} --approve

echo
echo creating iamserviceaccount via eksctl
eksctl create iamserviceaccount \
   --cluster=${CLUSTER} \
   --namespace=kube-system \
   --name=aws-load-balancer-controller \
   --role-name AmazonEKSLoadBalancerControllerRole \
   --attach-policy-arn=arn:aws:iam::${ACCOUNT}:policy/AWSLoadBalancerControllerIAMPolicy \
   --approve
