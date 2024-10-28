#!/usr/bin/env bash

NS=${1}
JOB=${2}
SLEEP=4

echo
echo waiting for job ${NS}:${JOB} to be created

while true; do
  kubectl wait --for=condition=complete -n ${NS} job ${JOB}
  if [ $? -eq 0 ]; then
    echo found completed job ${NS}:${JOB}
    break
  fi

  echo
  echo waiting for job ${NS}:${JOB} to be created
  sleep ${SLEEP}
done
