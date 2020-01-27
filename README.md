# Cloud Infrastructure k8s by xkey

## Table of contents

- [Quick start on AWS](#quick-start-on-AWS-EKS)

## Quick start on AWS-EKS

Install

- AWS-CLI
- Kubectl install 
- Eksctl install

### AWS-CLI install 
aws-cli - pip3 install awscli --upgrade --user
aws --version

### kubectl install 
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl


### eksctl install

curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version