#!/usr/bin/env bash

echo
echo applying bluegreen demo...
kubectl apply -f .

sleep 4

./status.sh
