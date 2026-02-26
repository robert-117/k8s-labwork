# Autoscaling and Load testing

## Setup
Deploy pods and double-check metrics server is deploy
- `kubectl apply -n ns1 -f manifests/deployment.yaml`
- `kubectl top pods -n ns1`

## What I did
### Generate CPU load to deployment with autoscaling configured
- `kubectl autoscale deployment webapp -n ns1 --cpu=50% --min=1 --max=10`
- exec'd into pod and ran loop to generate cpu load
  - `kubectl exec -n ns1 -it webapp-5fc6f58fbf-hjzrg -- sh -c 'yes > /dev/null'`
- observed scaling and results:
```
$ kubectl get hpa -n ns1 -w
NAME     REFERENCE           TARGETS       MINPODS   MAXPODS   REPLICAS   AGE
webapp   Deployment/webapp   cpu: 1%/50%   1         10        1          3d
webapp   Deployment/webapp   cpu: 90%/50%   1         10        1          3d
webapp   Deployment/webapp   cpu: 229%/50%   1         10        2          3d
webapp   Deployment/webapp   cpu: 125%/50%   1         10        4          3d
webapp   Deployment/webapp   cpu: 58%/50%    1         10        5          3d
webapp   Deployment/webapp   cpu: 63%/50%    1         10        5          3d
webapp   Deployment/webapp   cpu: 45%/50%    1         10        5          3d
webapp   Deployment/webapp   cpu: 46%/50%    1         10        5          3d
```
- double-check details from scaling
  - `kubectl describe deployment -n ns1 webapp`