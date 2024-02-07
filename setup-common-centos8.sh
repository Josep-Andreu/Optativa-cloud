#! /bin/bash
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
localectl set-locale LANG=en_US.UTF-8
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm
dnf install docker-ce --nobest -y
systemctl enable --now docker
cat > /etc/docker/daemon.json <<EOF
echo '{
  "exec-opts": ["native.cgroupdriver=systemd"]
}'
EOF
systemctl restart docker
cat > /etc/yum.repos.d/kubernetes.repo << EOF
[kubernetes]

name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
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
sed -i 's/.*swap.*//g' /etc/fstab
systemctl restart containerd
