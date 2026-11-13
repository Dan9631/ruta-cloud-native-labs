El API server expone endpoints de salud. Consúltalos con `kubectl`:

`kubectl cluster-info`{{exec}}

`kubectl get --raw '/readyz?verbose' | grep etcd`{{exec}}

`kubectl get --raw '/livez'; echo`{{exec}}

`kubectl get componentstatuses`{{exec}}

```text
Kubernetes control plane is running at https://...:6443
CoreDNS is running at https://...:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
[+]etcd ok
[+]etcd-readiness ok
ok
Warning: v1 ComponentStatus is deprecated in v1.19+
NAME                 STATUS    MESSAGE   ERROR
controller-manager   Healthy   ok
scheduler            Healthy   ok
etcd-0               Healthy   ok
```

Ve la lista completa de comprobaciones:

`kubectl get --raw '/readyz?verbose' | head -20`{{exec}}

**Qué observar**

- `cluster-info` da la URL del API server (puerto **6443**) y del DNS del clúster.
- `/readyz` incluye la conexión con etcd: si etcd cae, el API server deja de estar listo.
- `/livez` responde si el proceso está vivo; `/readyz`, si puede atender peticiones. Añade `?verbose` para ver cada comprobación.
- `componentstatuses` todavía responde, pero está **obsoleto**. Usa `/livez` y `/readyz`.

Este paso no tiene comprobación. Pulsa **NEXT** para terminar.
