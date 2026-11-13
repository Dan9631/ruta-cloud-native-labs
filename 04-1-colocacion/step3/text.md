Limpia lo del paso anterior:

`kubectl label node node01 lab-04-gpu-`{{exec}}

`kubectl delete deploy web-libre -n lab-04 && kubectl delete pod manual -n lab-04`{{exec}}

Crea un Deployment que solo quiere nodos `disktype=ssd` y un Pod que pide `disktype=nvme`, que no tiene ningún nodo:

`cat /root/lab/03-web-ssd.yaml`{{exec}}

`kubectl apply -f /root/lab/03-web-ssd.yaml -f /root/lab/04-pod-imposible.yaml`{{exec}}

`kubectl get pods -n lab-04 -o wide`{{exec}}

```text
NAME                       READY   STATUS    RESTARTS   AGE   IP           NODE
imposible                  0/1     Pending   0          4s    <none>       <none>
web-ssd-845b59c46c-hlnlm   1/1     Running   0          9s    10.244.0.9   controlplane
web-ssd-845b59c46c-jfx7h   1/1     Running   0          9s    10.244.0.8   controlplane
web-ssd-845b59c46c-wb59t   1/1     Running   0          9s    10.244.0.10  controlplane
```

Diagnostica el Pod `Pending` como lo harías en un clúster real:

`kubectl describe pod imposible -n lab-04 | tail -n 8`{{exec}}

`kubectl get events -n lab-04 --field-selector reason=FailedScheduling`{{exec}}

```text
Node-Selectors:              disktype=nvme
...
Events:
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  7s    default-scheduler  0/2 nodes are available: 2 node(s) didn't match Pod's node affinity/selector. preemption: 0/2 nodes are available: 2 Preemption is not helpful for scheduling.
```

**Qué observar**

- Las 3 réplicas de `web-ssd` cayeron en `controlplane`, el único nodo `disktype=ssd`.
- El mensaje de `FailedScheduling` resume el **filtrado**: de 2 nodos, los 2 descartados por no cumplir el selector. En el lab local verías `0/3`, con 1 nodo descartado por el taint del plano de control.
- «Preemption is not helpful» significa que desalojar otros Pods no arreglaría nada.
- Las soluciones serían corregir el `nodeSelector` (borrar y recrear el Pod) o etiquetar algún nodo con `disktype=nvme`.

Pulsa **CHECK**.
