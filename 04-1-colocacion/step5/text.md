Limpia lo del paso anterior y pon un taint en `node01`:

`kubectl delete deploy web-afinidad cache -n lab-04`{{exec}}

`kubectl taint nodes node01 lab-04-dedicado=batch:NoSchedule`{{exec}}

`kubectl describe node node01 | grep Taints`{{exec}}

```text
node/node01 tainted
Taints:             lab-04-dedicado=batch:NoSchedule
```

Crea un Deployment sin tolerations y otro que tolera el taint:

`cat /root/lab/08-batch-tolerante.yaml`{{exec}}

`kubectl apply -f /root/lab/07-web-sin-tolerancia.yaml -f /root/lab/08-batch-tolerante.yaml`{{exec}}

`kubectl get pods -n lab-04 -o wide --sort-by=.spec.nodeName`{{exec}}

```text
NAME                           READY   STATUS    RESTARTS   AGE   IP            NODE
batch-6f7d8cbffc-jm8j8         1/1     Running   0          13s   10.244.0.27   controlplane
batch-6f7d8cbffc-rtblq         1/1     Running   0          12s   10.244.0.28   controlplane
web-sin-tol-698f8449d5-5klw5   1/1     Running   0          15s   10.244.0.26   controlplane
web-sin-tol-698f8449d5-845d2   1/1     Running   0          15s   10.244.0.25   controlplane
web-sin-tol-698f8449d5-8m9mb   1/1     Running   0          14s   10.244.0.24   controlplane
web-sin-tol-698f8449d5-qqc6n   1/1     Running   0          15s   10.244.0.23   controlplane
batch-6f7d8cbffc-stpmf         1/1     Running   0          12s   10.244.1.18   node01
batch-6f7d8cbffc-zqvtw         1/1     Running   0          12s   10.244.1.17   node01
```

Conviértelo en un nodo dedicado de verdad: la nueva versión de `batch` añade node affinity a `zona-b`.

`cat /root/lab/09-batch-dedicado.yaml`{{exec}}

`kubectl apply -f /root/lab/09-batch-dedicado.yaml`{{exec}}

`kubectl rollout status deploy/batch -n lab-04`{{exec}}

`kubectl get pods -n lab-04 -l app=batch -o wide`{{exec}}

```text
NAME                     READY   STATUS    RESTARTS   AGE   IP            NODE
batch-764d454f97-2mbg2   1/1     Running   0          15s   10.244.1.22   node01
batch-764d454f97-9s5tz   1/1     Running   0          16s   10.244.1.21   node01
batch-764d454f97-qsjbt   1/1     Running   0          20s   10.244.1.20   node01
batch-764d454f97-rhznk   1/1     Running   0          22s   10.244.1.19   node01
```

Quita el taint (fíjate en el guion final) y mira qué pasa con los Pods que ya existen:

`kubectl taint nodes node01 lab-04-dedicado=batch:NoSchedule-`{{exec}}

`kubectl get pods -n lab-04 -o wide --sort-by=.spec.nodeName`{{exec}}

```text
node/node01 untainted
(web-sin-tol sigue entero en controlplane; batch sigue en node01)
```

**Qué observar**

- **Todas** las réplicas de `web-sin-tol` están en `controlplane`: el taint las expulsa de `node01`.
- `batch`, que sí tolera el taint, se repartió entre **los dos** nodos: la toleration permite entrar, no obliga. Tu reparto puede no ser 2 y 2.
- Toleration + affinity = nodo dedicado: los Pods ajenos no entran y los tuyos solo van allí.
- Al quitar el taint, **nada se mueve**: el scheduler solo decide al crear el Pod.
- Con un taint `NoExecute`, los Pods sin toleration sí se habrían desalojado al ponerlo. No lo probamos porque afectaría a los Pods del sistema que corren en ese nodo.

Pulsa **CHECK**.
