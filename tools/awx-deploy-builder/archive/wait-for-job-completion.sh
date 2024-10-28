#!/usr/bin/env bash

NS=${1}
JOB=${2}
SLEEP=30

echo

while true; do
  echo kubectl wait --for=condition=complete -n ${NS} job ${JOB}
  kubectl wait --for=condition=complete --timeout=0 -n ${NS} job ${JOB}
  if [ $? -eq 0 ]; then
    echo "found completed job ${NS}:${JOB}"
    break
  fi

  echo
  echo "waiting ${SLEEP} seconds for job ${NS}:${JOB} to be created and completed"
  sleep ${SLEEP}
done
