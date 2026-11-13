Limpia lo del paso anterior:

`kubectl delete deploy web-ssd -n lab-04 && kubectl delete pod imposible -n lab-04`{{exec}}

Lee los dos manifiestos. `web-afinidad` **exige** estar en `zona-a` o `zona-b` y **prefiere** disco `hdd`. `cache` no admite dos réplicas en el mismo nodo:

`cat /root/lab/05-web-afinidad.yaml`{{exec}}

`cat /root/lab/06-cache-anti-afinidad.yaml`{{exec}}

`kubectl apply -f /root/lab/05-web-afinidad.yaml -f /root/lab/06-cache-anti-afinidad.yaml`{{exec}}

`kubectl get pods -n lab-04 -o wide`{{exec}}

```text
NAME                            READY   STATUS    RESTARTS   AGE   IP            NODE
cache-56cb56479b-fbdjk          1/1     Running   0          10s   10.244.1.16   node01
cache-56cb56479b-sbhm8          1/1     Running   0          10s   10.244.0.21   controlplane
cache-56cb56479b-zhqxz          0/1     Pending   0          10s   <none>        <none>
web-afinidad-5c547587d9-4ctg8   1/1     Running   0          14s   10.244.1.15   node01
web-afinidad-5c547587d9-f4fv4   1/1     Running   0          14s   10.244.1.13   node01
web-afinidad-5c547587d9-gf4d9   1/1     Running   0          14s   10.244.1.14   node01
web-afinidad-5c547587d9-hqf2k   1/1     Running   0          14s   10.244.1.12   node01
```

`kubectl get events -n lab-04 --field-selector reason=FailedScheduling`{{exec}}

```text
pod/cache-56cb56479b-zhqxz   0/2 nodes are available: 2 node(s) didn't match pod anti-affinity rules. ...
```

**Qué observar**

- `web-afinidad` podía ir a los dos nodos (los dos cumplen la regla *required* de zona), pero la preferencia `disktype=hdd` con peso 100 hace que el scheduler puntúe más alto a `node01`. Es una preferencia, no una obligación: si `node01` se llenara, usaría `controlplane`.
- Con `cache`, la anti-affinity por `kubernetes.io/hostname` impide dos réplicas en el mismo nodo. Hay 2 nodos, así que la tercera réplica queda `Pending`. Así se protege una aplicación con estado frente a la caída de un nodo.
- Esto se comporta igual que en el lab local: allí también había solo 2 nodos disponibles para tus Pods.

Pulsa **CHECK**.
