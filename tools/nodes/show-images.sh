
#main-worker
# NAME                 STATUS   ROLES           AGE   VERSION
# main-control-plane   Ready    control-plane   23h   v1.29.2
# main-worker          Ready    <none>          23h   v1.29.2
# main-worker2         Ready    <none>          23h   v1.29.2
# main-worker3         Ready    <none>          23h   v1.29.2

for i in "" 2 3
do
  node="main-worker${i}"
  echo
  echo images on: $node
  kubectl node-shell $node -- crictl images 2> /dev/null
done
