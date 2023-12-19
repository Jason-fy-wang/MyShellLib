
kubeadm init --cri-socket=unix:///run/containerd/containerd.sock
kubeadm init --apiserver-advertise-address=192.168.72.150 --pod-network-cidr 192.168.0.0/16 --cri-socket=unix:///var/run/cri-dockerd.sock


cat <<EOF | tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install containerd.io -y


kubeadm config images list
registry.k8s.io/kube-apiserver:v1.28.4
registry.k8s.io/kube-controller-manager:v1.28.4
registry.k8s.io/kube-scheduler:v1.28.4
registry.k8s.io/kube-proxy:v1.28.4
registry.k8s.io/pause:3.9
registry.k8s.io/etcd:3.5.9-0
registry.k8s.io/coredns/coredns:v1.10.1
registry.k8s.io/pause:3.6

# download images
images=(
  kube-apiserver:v1.28.4
  kube-controller-manager:v1.28.4
  kube-scheduler:v1.28.4
  kube-proxy:v1.28.4
  pause:3.6
  etcd:3.5.9-0
  coredns:v1.10.1
)

for imageName in ${images[@]} ; do
    docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
    docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName registry.k8s.io/$imageName
    #docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
done




# download image from aliyun
kubeadm init --image-repository registry.aliyuncs.com/google_containers --kubernetes-version=v1.28.4 --pod-network-cidr=10.244.0.0/16

kubeadm init --kubernetes-version=v1.25.6 --pod-network-cidr=10.224.0.0/16 --apiserver-advertise-address=192.168.30.15 --cri-socket unix:///run/docker.sock --image-repository=registry.aliyuncs.com/google_containers


kubeadm init --kubernetes-version=v1.28.4 --pod-network-cidr=10.224.0.0/16 --apiserver-advertise-address=192.168.30.15 --cri-socket unix:///var/run/containerd/containerd.sock --image-repository=registry.aliyuncs.com/google_containers


/run/containerd/containerd.sock






# 生成默认文件
containerd config default > /etc/containerd/config.toml
# 编辑配置文件 设置驱动方式为systemd 设置pause镜像 镜像仓库的加速器
sed -i "s#SystemdCgroup = false#SystemdCgroup = true#g" /etc/containerd/config.toml
sed -i "s#registry.k8s.io#registry.cn-hangzhou.aliyuncs.com/google_containers#g" /etc/containerd/config.toml
sed -i "/\[plugins.\"io.containerd.grpc.v1.cri\".registry.mirrors\]/a\        [plugins.\"io.containerd.grpc.v1.cri\".registry.mirrors.\"docker.io\"]" /etc/containerd/config.toml
sed -i "/\[plugins.\"io.containerd.grpc.v1.cri\".registry.mirrors.\"docker.io\"\]/a\          endpoint = [\"https://hub-mirror.c.163.com\",\"https://docker.mirrors.ustc.edu.cn\",\"https://registry.docker-cn.com\"]" /etc/containerd/config.toml
sed -i "/endpoint = \[\"https:\/\/hub-mirror.c.163.com\",\"https:\/\/docker.mirrors.ustc.edu.cn\",\"https:\/\/registry.docker-cn.com\"]/a\        [plugins.\"io.containerd.grpc.v1.cri\".registry.mirrors.\"registry.k8s.io\"]" /etc/containerd/config.toml
sed -i "/\[plugins.\"io.containerd.grpc.v1.cri\".registry.mirrors.\"registry.k8s.io\"\]/a\          endpoint = [\"registry.cn-hangzhou.aliyuncs.com/google_containers\"]" /etc/containerd/config.toml
sed -i "/endpoint = \[\"registry.cn-hangzhou.aliyuncs.com\/google_containers\"]/a\        [plugins.\"io.containerd.grpc.v1.cri\".registry.mirrors.\"k8s.gcr.io\"]" /etc/containerd/config.toml
sed -i "/\[plugins.\"io.containerd.grpc.v1.cri\".registry.mirrors.\"k8s.gcr.io\"\]/a\          endpoint = [\"registry.cn-hangzhou.aliyuncs.com/google_containers\"]" /etc/containerd/config.toml
systemctl daemon-reload
systemctl enable containerd && systemctl restart containerd


kubeadm join 192.168.30.15:6443 --token 2afhcm.yqp3iips26y4ffa5 \
	--discovery-token-ca-cert-hash sha256:41a9dd276a4c22bddd6ae1ecb4e949999fdd4bba65cbc6319bb0094f277a7981