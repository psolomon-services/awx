

eksctl create cluster --profile mgmt -N 3 --name argocd

# attach before turning on cloudwatch addon
# get cloudwatch addon
aws --profile mgmt iam attach-role-policy --role-name eksctl-argocd-nodegroup-ng-d30da19-NodeInstanceRole-8BTzKEDm8ng9 --policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy

curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.2/docs/install/iam_policy.json

aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json

# first create IAM OIDC provider

https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html

cluster_name=argocd
oidc_id=$(aws eks describe-cluster --name $cluster_name --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)

eksctl create iamserviceaccount \
  --cluster=argocd \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=arn:aws:iam::111122223333:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve

NS=apps envsubst < ingress.yml

cat ingress.yaml

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ${NS}-ingress
  namespace: ${NS}
  annotations:
    alb.ingress.kubernetes.io/load-balancer-name: ${NS}-ingress
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/healthcheck-path: /healthz
spec:
  ingressClassName: alb
  rules:
    - host: first.pauljsolomon.net
      http:
        paths:
          #- path: /first
          - path: /
            pathType: Prefix
            backend:
              service:
                name: first
                port:
                  name: svc-port
    - host: second.pauljsolomon.net
      http:
        paths:
          #- path: /second
          - path: /
            pathType: Prefix
            backend:
              service:
                name: second
                port:
                  name: svc-port
    - host: error.pauljsolomon.net
      http:
        paths:
          #- path: /error
          - path: /
            pathType: Prefix
            backend:
              service:
                name: error
                port:
                  name: svc-port
