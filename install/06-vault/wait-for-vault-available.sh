#!/usr/bin/env bash

EXTRA_SLEEP=5
SLEEP=10

NS=${1}
DEPLOY=${2}
STATUS=${3}

NS=vault
DEPLOY=vault-0

echo
echo "waiting for deploy ${NS}:${DEPLOY} to be ${STATUS}"
echo

while true; do
  echo kubectl wait --for=condition=${STATUS} -n ${NS} pod ${DEPLOY} --timeout=0s
  kubectl wait --for=condition=${STATUS} -n ${NS} pod ${DEPLOY} --timeout=0s
  if [ $? -eq 0 ]; then
    echo "found ${STATUS} deploy ${NS}:${DEPLOY}"
    break
  fi

  echo
  echo sleeping ${SLEEP} secs, for deploy ${NS}:${DEPLOY} to be ${STATUS}, EXTRA_SLEEP: ${EXTRA_SLEEP}
  sleep ${SLEEP}
done

if [[ ${EXTRA_SLEEP} -gt 0 ]]; then
  echo
  echo waiting ${EXTRA_SLEEP} seconds before proceeding
  sleep ${EXTRA_SLEEP}
fi
