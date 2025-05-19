## Pod Affinity 

Now [Pod Affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#inter-pod-affinity-and-anti-affinity) is an expression to allow us to state that pods should gravitate towards other pods

```
kubectl apply -f pod-affinity.yaml

# observe where pods get deployed
kubectl get pods -owide

kubectl scale deploy app-disk --replicas 3
kubectl scale deploy web-disk --replicas 3
```

## Pod Anti-Affinity

Let's say we observe our `app-disk` application disk usage is quite intense, and we would like to prevent `app-disk` pods from running together. </br>
This is where anti-affinity comes in:

```
podAntiAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
  - labelSelector:
      matchExpressions:
      - key: app
        operator: In
        values:
        - app-disk
    topologyKey: "kubernetes.io/hostname"
```

After applying the above, we can roll it out and observe scheduling:

```
kubectl scale deploy app-disk --replicas 0
kubectl scale deploy web-disk --replicas 0
kubectl apply -f node-affinity.yaml
kubectl get pods -owide

kubectl scale deploy app-disk --replicas 2 #notice pending pods when scaling to 3
kubectl get pods -owide
kubectl scale deploy web-disk --replicas 2
kubectl get pods -owide

```

