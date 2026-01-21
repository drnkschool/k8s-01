# k8s-01


################################# 01_init ##################################


.sh script in folder 01_init




Error when kubeadm init:

kubeadm init --pod-network-cidr=10.0.0.0/16
I1122 10:28:48.950540    2156 version.go:261] remote version is much newer: v1.34.2; falling back to: stable-1.32
[init] Using Kubernetes version: v1.32.10
[preflight] Running pre-flight checks
error execution phase preflight: [preflight] Some fatal errors occurred:
	[ERROR FileContent--proc-sys-net-ipv4-ip_forward]: /proc/sys/net/ipv4/ip_forward contents are not set to 1
[preflight] If you know what you are doing, you can make a check non-fatal with `--ignore-preflight-errors=...`
To see the stack trace of this error execute with --v=5 or higher

What you should to do:

rm -f /etc/containerd/config.toml
systemctl restart containerd
modprobe br_netfilter
echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
echo 1 > /proc/sys/net/ipv4/ip_forward
kubeadm init --pod-network-cidr=10.0.0.0/16


################################ 02_cilium ####################################


1) on ServerHost do commands:

### INSTALL CILIUM CLI ###

# Determine the latest stable version and target architecture
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then
  CLI_ARCH=arm64
fi

# Download the tarball and its SHA-256 checksum
curl -L --fail --remote-name-all \
  https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}

# Verify the checksum before extraction
sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum

# Extract and install the binary
sudo tar xzvf cilium-linux-${CLI_ARCH}.tar.gz -C /usr/local/bin

# Remove downloaded files
rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}


2) .sh script in folder 02_cilium



################################ 03_metallb ######################################


.sh script in folder 03_metallb









############################### 04_longhorn #####################################

1) do ansible role longhorn_depend
2) .sh script in folder 04_longhorn





############################### 05_nginx #########################################

.sh script in folder 05_nginx





