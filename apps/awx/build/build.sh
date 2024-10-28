#!/usr/bin/env bash

TAG=$(< VERSION)

echo
echo removing old dirs
rm -rf ./argocd-test
rm -rf ./.ssh
rm -f .vault-password

echo
echo copying code and perms
rm -rf /tmp/argocd-test
cp -rf ~/repos/argocd-test /tmp
cp -rf /tmp/argocd-test .
cp -rf ~/.ssh .
cp -rf argocd-test/.vault-password .

echo
echo building ansible build image for TAG ${TAG}
echo docker build . -t ansible:${TAG}
docker build . -t ansible:${TAG}

echo
echo loading images into kind cluster
echo kind load docker-image ansible:${TAG} --name main
kind load docker-image ansible:${TAG} --name main
echo
