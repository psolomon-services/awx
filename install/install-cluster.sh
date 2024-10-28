#!/usr/bin/env bash

DIRS=$(find . -name "[0-9]*" -type d | sort)
SLEEP=45

echo
echo installing cluster
echo

for i in $DIRS
do
  echo
  echo
  echo
  echo ========================================================================
  echo running install for $i
  (cd $i; ./install.sh)
  echo ========================================================================
  echo
done

echo
echo re-running argocd finish script sleeping for ${SLEEP} secs
sleep ${SLEEP}

cd 10-argocd
./install-finish.sh

echo
echo ===============================================================================
echo ===============================================================================
echo "DO NOT FORGET TO REBUILD AND PUSH ANY CLUSTER IMAGES (I.E. AWX)"
echo ===============================================================================
echo ===============================================================================
