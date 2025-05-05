# kubernetes configmap and secret

### What is a config map in Kubernetes?

- When your manifest grows it becomes difficult to manage multiple env vars
- You can take this out of the manifest and store as a config map object in the key-value pair
- Then you can inject that config map into the pod
- You can reuse the same config map into multiple pods

#### Sample command to create a config map

```
- kubectl create cm <configmapname> --from-literal=color=blue \
--from-literal=color=red
```
Where color=clue is the key and value of the config map


#### Secrets

Follow the doc: https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#define-container-environment-variables-using-secret-data

### Sample YAMLs used in the demo

```yaml
apiVersion: v1
data:
  firstname: piyush
  lastname: sachdeva
kind: ConfigMap
metadata:
  name: app-cm
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app.kubernetes.io/name: MyApp
spec:
  containers:
  - name: myapp-container
    image: busybox:1.28
    env:
    - name: FIRSTNAME
      valueFrom:
        configMapKeyRef:
          name: app-cm
          key: firstname
    command: ['sh', '-c', 'echo The app is running! && sleep 3600']
```

In this exercise, you will explore config maps, secrets and environment variables

### Task details
1. Perform the task given here : https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#define-container-environment-variables-using-secret-data
