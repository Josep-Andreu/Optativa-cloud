#! /bin/bash
sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/CentOS-*.repo
sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/CentOS-*.repo
sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/CentOS-*.repo
dnf -y upgrade
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
modprobe br_netfilter
firewall-cmd --add-masquerade --permanent
firewall-cmd --reload
cat > /etc/sysctl.d/k8s.conf << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
swapoff -a
yum install -y glibc-langpack-en
dnf remove -y runc
localectl set-locale LANG=en_US.UTF-8
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf install -y containerd
dnf install docker-ce --nobest -y
systemctl enable --now docker
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
systemctl restart docker
cat > /etc/yum.repos.d/kubernetes.repo << EOF
[kubernetes]
name=Kubernetes 
baseurl=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/ 
enabled=1 
gpgcheck=1 
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/repodata/repomd.xml.key 
EOF
dnf upgrade -y
dnf install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet
cat > /etc/crictl.yaml << EOF
runtime-endpoint: unix:///var/run/containerd/containerd.sock
image-endpoint: unix:///var/run/containerd/containerd.sock
timeout: 2
debug: true
pull-image-on-create: false
EOF
sed -i "s/.*disabled_plugins.*/disabled_plugins = []/g" /etc/containerd/config.toml
echo root = \"/var/lib/containerd\" >> /etc/containerd/config.toml
echo state = \"/run/containerd\" >> /etc/containerd/config.toml
echo [grpc] >> /etc/containerd/config.toml
echo address = \"/run/containerd/containerd.sock\" >> /etc/containerd/config.toml
sed -i 's/.*swap.*//g' /etc/fstab
systemctl restart containerd
