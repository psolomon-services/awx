FROM python:3.9
RUN pip install ansible
RUN apt update; apt install -y inetutils-ping vim

COPY .ssh /root/.ssh
COPY argocd-test /root/argocd-test
COPY .vault-password /root/argocd-test
RUN chmod 400 /root/argocd-test/.vault-password

COPY content/deploy-awx.sh /root/argocd-test
RUN chmod +x /root/argocd-test/deploy-awx.sh

# moved to auto-generated
#COPY content/create-certs-and-secret.sh /root/argocd-test
#RUN chmod +x /root/argocd-test/create-certs-and-secret.sh

COPY content/wait-for-deploy-available.sh /root/argocd-test
RUN chmod +x /root/argocd-test/wait-for-deploy-available.sh

# install kubectl for troubleshooting
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin
