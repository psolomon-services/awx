#!/usr/bin/env bash
#
# TODO:PSOLOMON check if cluster already exists and act accordingly

CLUSTER=main

echo
echo deleting cluster ${CLUSTER}
echo eksctl delete cluster ${CLUSTER}
eksctl delete cluster ${CLUSTER}
