#!/bin.bash

### k8s default image. pull image from docker hub and re-rag them
# registry.k8s.io/kube-apiserver:v1.30.9
# registry.k8s.io/kube-controller-manager:v1.30.9
# registry.k8s.io/kube-scheduler:v1.30.9
# registry.k8s.io/kube-proxy:v1.30.9
# registry.k8s.io/coredns/coredns:v1.11.3
# registry.k8s.io/pause:3.9
# registry.k8s.io/etcd:3.5.15-0


images="registry.k8s.io/kube-apiserver:v1.30.9 registry.k8s.io/kube-controller-manager:v1.30.9  registry.k8s.io/kube-scheduler:v1.30.9 registry.k8s.io/kube-proxy:v1.30.9  registry.k8s.io/pause:3.9  registry.k8s.io/etcd:3.5.15-0 calico/node:v3.29.0 calico/cni:v3.29.0 calico/kube-controllers:v3.29.0 registry.k8s.io/coredns/coedns:v1.11.3"

### 其中: kube-proxy  etcd   pause calico/node calico/cni coedns 需要在 controller 和 worker-node 同时存在

images2="registry.k8s.io/coredns/coedns:v1.11.3"

for img in `echo $images`
do
    # myifeng/registry.k8s.io_kube-apiserver:v1.30.9
    dest=$(echo "$img" | sed -e 's#/#_#g' -e 's#\(.*\)#myifeng/\1#g')
    # registry_k8s_io_kube-apiserver_v1_30_9
    tar_package=$(echo "$img" | sed -e "s#[:./]#_#g")
    sudo docker pull  $dest
    sudo docker tag $dest $img
    sudo docker rmi $dest
    sudo docker save $img -o $tar_package.tar.gz
    sudo ctr --namespace k8s.io images import $tar_package.tar.gz

    rm -f $tar_package.tar.gz
done



