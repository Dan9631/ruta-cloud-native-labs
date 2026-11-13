El kubelet y el runtime de contenedores no son Pods: son servicios del sistema operativo de cada nodo. Míralos en `controlplane`:

`systemctl status kubelet --no-pager | head -5`{{exec}}

`systemctl list-units --type=service --no-pager | grep -E 'kubelet|containerd|crio'`{{exec}}

`crictl` habla CRI directamente con el runtime, igual que el kubelet. Pregúntale quién es:

`crictl version`{{exec}}

`crictl ps | head`{{exec}}

Salta a `node01` y mira sus *sandboxes* de Pod del namespace `kube-system`:

`ssh node01 systemctl is-active kubelet`{{exec}}

`ssh node01 crictl pods --namespace kube-system`{{exec}}

```text
POD ID          CREATED       STATE   NAME               NAMESPACE     ATTEMPT   RUNTIME
cd55453c48c9d   2 hours ago   Ready   kube-proxy-mg8bd   kube-system   0         (default)
...
```

Si prefieres trabajar dentro de `node01`, entra con `ssh node01`{{copy}} y sal con `exit`.

**Qué observar**

- `kubelet` y el runtime (el que diga `crictl version` en `RuntimeName`) son **servicios de systemd**, en el plano de control y en cada nodo de trabajo. Por eso no aparecen en `kubectl get pods`.
- `crictl ps` en `controlplane` muestra los contenedores de etcd, kube-apiserver, kube-controller-manager y kube-scheduler: los static pods del paso 2 vistos desde el runtime.
- En `node01` solo hay sandboxes de los Pods que el kubelet de ese nodo pidió crear, como los de los DaemonSets. El plugin CNI sale en esa lista solo si vive en `kube-system`; quita `--namespace kube-system` para ver todos los del nodo.
- En el lab local, los «nodos» eran contenedores de Podman y entrabas con `podman exec`. Aquí son máquinas y entras por SSH, como en un clúster real.

Este paso no tiene comprobación. Pulsa **NEXT**.
