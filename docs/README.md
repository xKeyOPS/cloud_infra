<p align="center">


![alt text][logo]

[logo]: Devops@4x-min-768x590.png


  <h1 align="center">Cloud DevOps Engineer</h1>
</p>

<h1 align="center">Cloud Infrastructure by xkey </h1>

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

### Kubectl install
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

### EKSctl install

curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

## What's included

mkdir kubernetes

```text
kubernetes/kubectl
kubernetes/eksctl
```

## Instal EKS cluster

```
eksctl create cluster --name app-dev-k8s
```

## Delete EKS cluster
```
eksctl delete cluster --name app-dev-k8s
```

# Install with yaml config

## Simple yaml config

```

---
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: al9-k8s
  region: eu-central-1

nodeGroups:
  - name: al9-1
    instanceType: m5.large
    minSize: 1
    maxSize: 2
    iam:
      withAddonPolicies:
        albIngress: true
        autoScaler: true

```

```
eksctl create cluster -f simple-yaml-config.yml
```