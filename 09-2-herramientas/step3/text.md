Primero borra la copia del paso anterior:

`kubectl delete pod api-debug -n lab-09`{{exec}}

**`kubectl top`: consumo real.** Necesita metrics-server, que ya se instaló al arrancar. Si responde `Metrics API not available`, espera un minuto y repite:

`kubectl top pods -n lab-09 --sort-by=memory`{{exec}}

`kubectl top nodes`{{exec}}

```text
NAME                        CPU(cores)   MEMORY(bytes)
frontend-7bb584f994-hzrdq   1m           11Mi
frontend-7bb584f994-47mg7   7m           5Mi
...
```

**Salud de los nodos.** `describe node` muestra las *Conditions* y los recursos asignados:

`kubectl get nodes`{{exec}}

`kubectl describe node node01 | grep -E 'Ready|Pressure|cpu|memory' | head -12`{{exec}}

**El control plane.** En un clúster kubeadm sus componentes son static pods en `kube-system`:

`kubectl get pods -n kube-system`{{exec}}

```text
NAME                                   READY   STATUS    RESTARTS   AGE
etcd-controlplane                      1/1     Running   0          75m
kube-apiserver-controlplane            1/1     Running   0          75m
kube-controller-manager-controlplane   1/1     Running   0          75m
kube-scheduler-controlplane            1/1     Running   0          75m
...
```

El apiserver publica sus chequeos de salud:

`kubectl get --raw='/readyz?verbose' | tail -3`{{exec}}

```text
[+]shutdown ok
readyz check passed
```

La terminal está en el nodo `controlplane`, así que puedes ver los manifiestos de esos static pods directamente:

`ls /etc/kubernetes/manifests`{{exec}}

```text
etcd.yaml
kube-apiserver.yaml
kube-controller-manager.yaml
kube-scheduler.yaml
```

**Qué observar**

- `top` solo muestra Pods en ejecución (los que están en `Pending` o en *back-off* no aparecen) y metrics-server tarda alrededor de un minuto en ver Pods nuevos. Para un `OOMKilled`, compara el consumo esperado con el `limits.memory` del manifiesto.
- **Allocated resources** en `describe node` es la suma de los `requests` frente a la capacidad: la clave para entender un `Insufficient cpu`.
- Si borras uno de los archivos de `/etc/kubernetes/manifests`, el kubelet detiene ese componente; si lo restauras, lo vuelve a arrancar. No lo hagas aquí.
- `kubectl get componentstatuses` está obsoleto: usa `/livez` y `/readyz`.

Pulsa **CHECK**.
