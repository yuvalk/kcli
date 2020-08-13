export ROOK_VERSION={{ 'rook/rook' | latestversion }}
kubectl create -f https://raw.githubusercontent.com/rook/rook/$ROOK_VERSION/cluster/examples/kubernetes/ceph/common.yaml
kubectl create -f https://raw.githubusercontent.com/rook/rook/$ROOK_VERSION/cluster/examples/kubernetes/ceph/operator.yaml
kubectl create -f https://raw.githubusercontent.com/rook/rook/$ROOK_VERSION/cluster/examples/kubernetes/ceph/cluster.yaml

