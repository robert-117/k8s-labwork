# k8s-labwork

Practicing hands-on building and deployment

## Plan

1) [local cluster, deploy app, service exposure, scaling, configurations](https://github.com/robert-117/k8s-labwork/blob/main/basic-deployment/README.md)
2) [implement observability](https://github.com/robert-117/k8s-labwork/blob/main/observability/README.md)
3) autoscaling + load testing
4) implement deployment via terraform + EKS

All plans include manifests and documentation

## Initial steps for setup using Ubuntu
#### Install kind
```
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```
#### Install kubectl
```
sudo apt-get update
sudo apt-get install -y kubectl
```
#### Creating local k8s cluster
```
kind create cluster --name k8s-lab
```