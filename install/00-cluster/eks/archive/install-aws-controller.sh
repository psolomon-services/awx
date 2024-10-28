#!/bin/bash

helm repo add aws https://aws.github.io/eks-charts
helm repo update

# method 1: with Helm
# at the time of writing this gist, Helm doesn't support upgrading nor removing CRDs
# https://helm.sh/docs/chart_best_practices/custom_resource_definitions/#some-caveats-and-explanations
#helm install -n ingress-aws --create-namespace aws-load-balancer-controller-crds aws-load-balancer-controller-crds/aws-load-balancer-controller-crds --version 1.3.3

# method 2: without Helm; source: https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/deploy/installation/#summary

kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master"


# Optional: add the repo if you haven't already

helm upgrade -i -n ingress-aws --create-namespace ingress-aws aws/aws-load-balancer-controller -f aws-load-balancer-values.yml --version 1.4.3

# At the time of creating this gist, the Chart doesn't provide `controller.ingressClassResource.default` value
# the name `aws-alb` below is coming from the values file: https://gist.github.com/meysam81/d7d630b2c7e8075270c1319f16792fe2
kubectl annotate ingressclasses aws-alb ingressclass.kubernetes.io/is-default-class=true
