#!/usr/bin/env bash

NAME=jenkins
IMG=jenkins
TAG=$(< VERSION)

echo
echo building ${NAME} image
docker build . -t ${IMG}:${TAG}

echo
echo loading images into kind cluster
kind load docker-image ${IMG}:${TAG} --name main
echo
