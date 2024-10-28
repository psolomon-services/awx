#!/bin/sh
# For more information about shpod, check it out on GitHub:
# https://github.com/bretfisher/shpod
NAMESPACE=shpod
#NAMESPACE=kube-system
if [ -f shpod.yaml ]; then
  YAML=shpod.yaml
else
  YAML=https://k8smastery.com/shpod.yaml
fi
echo "Applying YAML: $YAML..."
kubectl apply -f $YAML
echo "Waiting for pod to be ready..."
kubectl wait --namespace=${NAMESPACE} --for condition=Ready pod/shpod
kubectl wait --namespace=${NAMESPACE} --for condition=Ready pod/shpod
echo "Attaching to the pod..."
kubectl attach --namespace=${NAMESPACE} -ti shpod </dev/tty
echo "Deleting pod..."
echo "
Note: it's OK to press Ctrl-C if this takes too long and you're impatient.
Clean up will continue in the background. However, if you want to restart
shpod, you need to wait a bit (about 30 seconds).
"
kubectl delete -f $YAML --now
echo "Done."
