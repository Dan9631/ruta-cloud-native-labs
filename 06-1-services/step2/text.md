Despliega whoami con 3 réplicas, su Service ClusterIP y un Pod `cliente` con busybox para probar la red desde dentro:

`cat /root/lab/02-svc-clusterip.yaml`{{exec}}

`kubectl apply -f /root/lab/01-whoami-deploy.yaml -f /root/lab/02-svc-clusterip.yaml -f /root/lab/03-cliente.yaml`{{exec}}

`kubectl rollout status deploy/whoami -n lab-06`{{exec}}

`kubectl get pods -n lab-06 -o wide`{{exec}}

`kubectl get svc -n lab-06`{{exec}}

```text
NAME     TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
whoami   ClusterIP   10.96.29.208   <none>        80/TCP    20s
```

Tus IPs serán otras.

**Qué observar**

- Las IPs de los Pods salen del rango de Pods del nodo donde corren (compáralas con el paso anterior).
- La ClusterIP sale de otro rango distinto, el de los Services (en un clúster kubeadm por defecto, `10.96.0.0/12`): es una IP virtual, no pertenece a ningún Pod.
- El Service elige los Pods por el label `app=whoami`, no por su nombre. `targetPort: http` apunta al puerto del contenedor por su nombre.

Pulsa **CHECK** cuando los 3 Pods de whoami y el Pod `cliente` estén `Running`.
