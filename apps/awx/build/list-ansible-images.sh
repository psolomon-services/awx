#!/usr/bin/env bash

for NODE in main-worker main-worker2 main-worker3 main-control-plane
do
  echo
  kubectl node-shell ${NODE} -- crictl images | grep ansible
done
