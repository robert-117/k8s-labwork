# Basic Deployment

## What I did
- created a local k8s cluster using kind
- deployed an nginx workload using deployments
- internally exposed CLusterIP service
- verified connectivity via port-forward
- scaled replicas and validated self-healing by deleting a pod

## Key commands
- `kind create cluster --name nginx-lab`
- `kubectl apply -f manifests/`
- `kubectl port-forward service/web 8080:80`
- `kubectl scale deployment webapp --replicas=3`
- `kubectl delete pod <pod_name>`

## Additional concepts
- namespace isolation
- ConfigMaps and Secret injection
- Liveness vs Readiness probes
- Resource requests and limits