FROM python:3.9
RUN pip install ansible
RUN apt update; apt install inetutils-ping

COPY .ssh /root/.ssh
COPY argocd-test /root/argocd-test
COPY .vault-password /root/argocd-test

COPY deploy-awx.sh /root/argocd-test
RUN chmod +x /root/argocd-test/deploy-awx.sh

COPY create-certs-and-secret.sh /root/argocd-test
RUN chmod +x /root/argocd-test/create-certs-and-secret.sh

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin
