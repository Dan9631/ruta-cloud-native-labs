Empieza por las máquinas. `-o wide` añade la IP, el sistema operativo y el runtime de cada nodo:

`kubectl get nodes -o wide`{{exec}}

`kubectl version`{{exec}}

Mira también si el plano de control admite Pods normales. Lo decide su taint:

`kubectl describe node controlplane | grep -A1 Taints`{{exec}}

Ahora los componentes del sistema y el nodo donde corre cada uno:

`kubectl get pods -n kube-system -o wide`{{exec}}

`kubectl get daemonsets,deployments -n kube-system`{{exec}}

El plugin de red (CNI) no siempre vive en `kube-system`. Busca todos los DaemonSets del clúster:

`kubectl get daemonsets -A`{{exec}}

En el lab local (kind, tres nodos) la lista de `kube-system` era así. Aquí cambian los nombres de los nodos, los sufijos y el plugin de red:

```text
NAME                                         READY   STATUS    ...   NODE
coredns-559f6c778d-dg64b                     1/1     Running   ...   kcna-control-plane
etcd-kcna-control-plane                      1/1     Running   ...   kcna-control-plane
kindnet-59cjz                                1/1     Running   ...   kcna-worker
kube-apiserver-kcna-control-plane            1/1     Running   ...   kcna-control-plane
kube-controller-manager-kcna-control-plane   1/1     Running   ...   kcna-control-plane
kube-proxy-b4q22                             1/1     Running   ...   kcna-worker2
kube-scheduler-kcna-control-plane            1/1     Running   ...   kcna-control-plane
...
```

**Qué observar**

- La columna `CONTAINER-RUNTIME` dice qué runtime usa cada nodo (por ejemplo `containerd://...`). Es con quien habla el kubelet por **CRI**.
- `kubectl version` muestra la versión del cliente y la del servidor. La política de *version skew* admite **±1 versión menor** entre kubectl y el API server; fuera de ese margen kubectl te avisa.
- Si `controlplane` tiene el taint `node-role.kubernetes.io/control-plane:NoSchedule`, tus Pods irán a `node01`. Si muestra `<none>`, este entorno lo ha quitado y pueden ir a cualquiera de los dos.
- Hay tres familias de componentes:
  - Los que terminan en `-controlplane` (etcd, kube-apiserver, kube-controller-manager, kube-scheduler) son **static pods**.
  - `kube-proxy` y el plugin CNI son **DaemonSets**: un Pod por nodo. Con dos nodos, `kube-proxy` tiene DESIRED = 2 (en el lab local eran 3). Algunos plugins CNI pueden sustituir a kube-proxy; si no lo ves, es por eso.
  - CoreDNS es un **Deployment**. El plugin CNI puede tener además algún Deployment propio, a veces en otro namespace.
- No hay ningún Pod «kubelet»: el kubelet **no es un Pod**. Lo verás en el paso 4.

Este paso no tiene comprobación. Pulsa **NEXT**.
