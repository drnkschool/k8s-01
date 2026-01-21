curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg 

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
chmod 644 /etc/apt/sources.list.d/kubernetes.list  

apt-get update
apt-get install -y kubeadm kubectl kubelet

wget https://github.com/containerd/containerd/releases/download/v2.0.4/containerd-2.0.4-linux-amd64.tar.gz
tar Cxzvf /usr/local containerd-2.0.4-linux-amd64.tar.gz
rm containerd-2.0.4-linux-amd64.tar.gz

mkdir /etc/containerd/
containerd config default > /etc/containerd/config.toml

wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
mv containerd.service /etc/systemd/system/

wget https://github.com/opencontainers/runc/releases/download/v1.2.6/runc.amd64
install -m 755 runc.amd64 /usr/local/sbin/runc
rm runc.amd64

wget https://github.com/containernetworking/plugins/releases/download/v1.6.2/cni-plugins-linux-amd64-v1.6.2.tgz
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.6.2.tgz
rm cni-plugins-linux-amd64-v1.6.2.tgz

systemctl daemon-reload
systemctl enable --now containerd

cat > /etc/crictl.yaml << _EOF
runtime-endpoint: unix:///var/run/containerd/containerd.sock
_EOF

kubeadm init --pod-network-cidr=10.0.0.0/16
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" > /etc/environment
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
