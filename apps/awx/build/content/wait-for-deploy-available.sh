#!/usr/bin/env bash

EXTRA_SLEEP=0
SLEEP=30
STATUS=Available

NS=${1}
DEPLOY=${2}
[[ $# -eq 3 ]] && EXTRA_SLEEP=$3

echo
echo "$0: waiting for deploy ${NS}:${DEPLOY} to be ${STATUS}"
echo

while true; do
  echo "kubectl wait --for=condition=${STATUS} -n ${NS} deploy ${DEPLOY} --timeout=0s"
  kubectl wait --for=condition=${STATUS} -n ${NS} deploy ${DEPLOY} --timeout=0s
  if [ $? -eq 0 ]; then
    echo "$0: found ${STATUS} deploy ${NS}:${DEPLOY}"
    break
  fi

  echo
  echo $0: sleeping ${SLEEP} secs, for deploy ${NS}:${DEPLOY} to be ${STATUS}, EXTRA_SLEEP: ${EXTRA_SLEEP}
  sleep ${SLEEP}
done

if [[ ${EXTRA_SLEEP} -gt 0 ]]; then
  echo
  echo $0: waiting ${EXTRA_SLEEP} seconds before proceeding
  sleep ${EXTRA_SLEEP}
fi
