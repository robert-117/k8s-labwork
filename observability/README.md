# Observability

## Setup
### Download prometheus-community helm chart
```
curl -L -o kube-prometheus-stack-82.1.1.tgz \
  https://github.com/prometheus-community/helm-charts/releases/download/kube-prometheus-stack-82.1.1/kube-prometheus-stack-82.1.1.tgz
```
### Install helm chart
```
helm install monitoring ./kube-prometheus-stack-82.1.1.tgz --namespace monitoring --create-namespace
```
### Access Grafana and Prometheus metrics
```
kubectl port-forward -n monitoring service/monitoring-grafana 3000:80
kubectl get secret -n monitoring monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 -d && echo
```

## What I did
- helm install for prometheus/alertmanager/grafana
- created monitoring namespace
- metrics observed during scaling and deletion of pods

## Lets break some stuff
### 1) checking pod restarts and termination
- `kubectl delete pod -n ns1 <pod_name>`
- confirm with PromQL queries in grafana
  - `sum by (namespace,pod) (increase(kube_pod_container_status_restarts_total{namespace="ns1"}[5m]))`
  - `sum by(namespace, pod) (increase(kube_pod_container_status_terminated{namespace="ns1"}[5m]))`
### 2) forcing a CrashLoopBackOff
```
kubectl patch deployment webapp -n ns1 --type='json' -p='[
  {"op":"replace","path":"/spec/template/spec/containers/0/image","value":"busybox"},
  {"op":"add","path":"/spec/template/spec/containers/0/command","value":["sh","-c","sleep 5; exit 1"]},
  {"op":"remove","path":"/spec/template/spec/containers/0/ports"}
]'
```
- confirm pods are in CrashLoopBackOff state
  - `kubectl get pods -n ns1 -w`
- confirm with PromQL queries in grafana
  - `topk(5, sum by (pod) (increase(kube_pod_container_status_restarts_total{namespace="ns1"}[5m])))`
- rollback changes
  - `kubectl rollout undo deployment/webapp -n ns1`
### 3) Throttle the CPU
```
kubectl patch deployment webapp -n ns1 --type='json' -p='[
  {"op":"add","path":"/spec/template/spec/containers/0/resources","value":{
    "requests":{"cpu":"50m","memory":"64Mi"},
    "limits":{"cpu":"100m","memory":"128Mi"}
  }}
]'
```
- generate a heavy load
  - `hey -z 2m http://localhost:8080/`
- confirm with PromQL queries in grafana
  - `sum(rate(container_cpu_cfs_throttled_periods_total{namespace="ns1"}[2m])) / sum(rate(container_cpu_cfs_periods_total{namespace="ns1"}[2m]))`