# https://discuss.kubernetes.io/t/etcd-backup-ssues/8304/2

kubectl describe pod -n kube-system etcd-main-control-plane

# go onto the control plane node
apt install etcd-client

ETCDCTL_API=3 etcdctl --endpoints=https://172.18.0.3:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key snapshot save /tmp/etcd.db --debug=true

ETCDCTL_CACERT=/etc/kubernetes/pki/etcd/ca.crt
ETCDCTL_CERT=/etc/kubernetes/pki/etcd/server.crt
ETCDCTL_COMMAND_TIMEOUT=5s
ETCDCTL_DEBUG=true
ETCDCTL_DIAL_TIMEOUT=2s
ETCDCTL_DISCOVERY_SRV=
ETCDCTL_DISCOVERY_SRV_NAME=
ETCDCTL_ENDPOINTS=[https://172.18.0.3:2379]
ETCDCTL_HEX=false
ETCDCTL_INSECURE_DISCOVERY=true
ETCDCTL_INSECURE_SKIP_TLS_VERIFY=false
ETCDCTL_INSECURE_TRANSPORT=true
ETCDCTL_KEEPALIVE_TIME=2s
ETCDCTL_KEEPALIVE_TIMEOUT=6s
ETCDCTL_KEY=/etc/kubernetes/pki/etcd/server.key
ETCDCTL_PASSWORD=
ETCDCTL_USER=
ETCDCTL_WRITE_OUT=simple
WARNING: 2024/07/24 12:56:35 [core]Adjusting keepalive ping interval to minimum period of 10s
WARNING: 2024/07/24 12:56:35 [core]Adjusting keepalive ping interval to minimum period of 10s
INFO: 2024/07/24 12:56:35 [core]parsed scheme: "endpoint"
INFO: 2024/07/24 12:56:35 [core]ccResolverWrapper: sending new addresses to cc: [{https://172.18.0.3:2379  <nil> 0 <nil>}]
INFO: 2024/07/24 12:56:35 [core]Subchannel Connectivity change to CONNECTING
{"level":"info","ts":1721825795.6389751,"caller":"snapshot/v3_snapshot.go:119","msg":"created temporary db file","path":"/tmp/etcd.db.part"}
INFO: 2024/07/24 12:56:35 [core]Channel Connectivity change to CONNECTING
INFO: 2024/07/24 12:56:35 [core]Subchannel picks a new address "https://172.18.0.3:2379" to connect
INFO: 2024/07/24 12:56:35 [core]Subchannel Connectivity change to READY
INFO: 2024/07/24 12:56:35 [core]Channel Connectivity change to READY
{"level":"info","ts":"2024-07-24T12:56:35.649Z","caller":"clientv3/maintenance.go:200","msg":"opened snapshot stream; downloading"}
{"level":"info","ts":1721825795.649458,"caller":"snapshot/v3_snapshot.go:127","msg":"fetching snapshot","endpoint":"https://172.18.0.3:2379"}
{"level":"info","ts":"2024-07-24T12:56:35.966Z","caller":"clientv3/maintenance.go:208","msg":"completed snapshot read; closing"}
{"level":"info","ts":1721825795.9665227,"caller":"snapshot/v3_snapshot.go:142","msg":"fetched snapshot","endpoint":"https://172.18.0.3:2379","size":"26 MB","took":0.327442158}
{"level":"info","ts":1721825795.9694173,"caller":"snapshot/v3_snapshot.go:152","msg":"saved","path":"/tmp/etcd.db"}
INFO: 2024/07/24 12:56:35 [core]Channel Connectivity change to SHUTDOWN
INFO: 2024/07/24 12:56:35 [core]Subchannel Connectivity change to SHUTDOWN

