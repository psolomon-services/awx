#!/usr/bin/env bash

IMG=$1

for NODE in main-worker main-worker2 main-worker3 main-control-plane
do
  echo
  kubectl node-shell ${NODE} -- crictl rmi docker.io/library/${IMG}
done
