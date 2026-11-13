Borra el static Pod «de verdad», quitando su archivo:

`rm /etc/kubernetes/manifests/lab-04-estatico.yaml`{{exec}}

`sleep 10; kubectl get pods -n lab-04`{{exec}}

```text
No resources found in lab-04 namespace.
```

Y quita otra vez el taint de `controlplane`, para que vuelva a aceptar Pods:

`kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule-`{{exec}}

Ahora, ¿quién planifica? El scheduler del clúster es otro static Pod:

`kubectl get pods -n kube-system -l component=kube-scheduler`{{exec}}

Crea un Pod que pide un scheduler que no existe:

`grep schedulerName /root/lab/16-otro-scheduler.yaml`{{exec}}

`kubectl apply -f /root/lab/16-otro-scheduler.yaml`{{exec}}

`kubectl get pod otro-scheduler -n lab-04 -o wide`{{exec}}

`kubectl get events -n lab-04 --field-selector involvedObject.name=otro-scheduler`{{exec}}

```text
NAME                          READY   STATUS    RESTARTS   AGE
kube-scheduler-controlplane   1/1     Running   0          40m
NAME             READY   STATUS    RESTARTS   AGE   IP       NODE
otro-scheduler   0/1     Pending   0          9s    <none>   <none>
No resources found in lab-04 namespace.
```

Ahora una PriorityClass. Es un objeto de todo el clúster, por eso lleva el prefijo `lab-04-`:

`kubectl apply -f /root/lab/17-prioridad.yaml`{{exec}}

`kubectl get priorityclass`{{exec}}

`kubectl get pod critico -n lab-04 -o jsonpath='{.spec.priorityClassName} {.spec.priority}'; echo`{{exec}}

`kubectl get pods -n kube-system -o custom-columns='POD:.metadata.name,PRIORIDAD:.spec.priorityClassName'`{{exec}}

```text
NAME                      VALUE        GLOBAL-DEFAULT   AGE   PREEMPTIONPOLICY
lab-04-alta               100000       false            2s    PreemptLowerPriority
system-cluster-critical   2000000000   false            41m   PreemptLowerPriority
system-node-critical      2000001000   false            41m   PreemptLowerPriority
lab-04-alta 100000
POD                                    PRIORIDAD
coredns-...                            system-cluster-critical
etcd-controlplane                      system-node-critical
kube-proxy-...                         system-node-critical
...
```

**Qué observar**

- `otro-scheduler` pide `schedulerName: mi-scheduler`, que no existe. A diferencia de un Pod que no cabe en ningún nodo, este `Pending` **no tiene ningún evento**: nadie lo está atendiendo. Esa ausencia de eventos es la pista.
- El admission controller tradujo el nombre de la clase a un número (`spec.priority`).
- Los componentes críticos del clúster usan las clases `system-*`, con valores muy por encima de cualquier clase de usuario.
- No confundas prioridad con QoS: la prioridad decide quién entra cuando el clúster está lleno; la QoS, a quién expulsa el kubelet cuando a un nodo le falta memoria.

Pulsa **CHECK**.
