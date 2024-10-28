#!/usr/bin/env bash

for NODE in main-worker main-worker2 main-worker3 main-control-plane
do
  echo
  echo kubectl node-shell ${NODE} -- ls -al
  kubectl node-shell ${NODE} -- ls -al
done
