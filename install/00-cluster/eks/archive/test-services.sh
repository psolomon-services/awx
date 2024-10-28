#!/usr/bin/env bash

for i in first second third fourth error;
do
  echo "Host: $i:  $(curl -s -H "Host: $i.pauljsolomon.net" apps-ingress-2031651306.us-east-1.elb.amazonaws.com/)"
done
