Para eliminar un static pod de verdad hay que borrar su archivo. Hazlo en `node01` y mira cómo desaparece:

`ssh node01 rm /etc/kubernetes/manifests/estatico.yaml`{{exec}}

`kubectl get pods -n lab-02`{{exec}}

Repite el último comando hasta que no quede ningún Pod (tarda unos segundos).

Ahora lee la configuración del plano de control. Las opciones de cada componente están en su manifiesto:

`grep -E 'image:|etcd-servers|authorization-mode|secure-port' /etc/kubernetes/manifests/kube-apiserver.yaml`{{exec}}

`grep -E 'image:|data-dir' /etc/kubernetes/manifests/etcd.yaml`{{exec}}

En un clúster kubeadm sin retocar verás algo así (las versiones de las imágenes dependen del clúster):

```text
    - --authorization-mode=Node,RBAC
    - --etcd-servers=https://127.0.0.1:2379
    - --secure-port=6443
    image: registry.k8s.io/kube-apiserver:v1.37.x
    - --data-dir=/var/lib/etcd
    image: registry.k8s.io/etcd:...
```

Los datos de etcd están en el disco de `controlplane`:

`ls /var/lib/etcd`{{exec}}

**Qué observar**

- Al borrar el archivo, el kubelet para el Pod y retira su mirror pod. `kubectl delete` no bastaba.
- El API server conoce la dirección de etcd con `--etcd-servers`. **Es el único componente que habla con etcd**; los demás hablan con el API server.
- Escucha en el puerto **6443** y autoriza con **RBAC** (más el autorizador `Node` para los kubelets).
- etcd guarda sus datos en el directorio de `--data-dir` del nodo. Eso es lo que hay que **respaldar**: si se pierde sin backup, se pierde la definición de todo el clúster.
- Si editas uno de estos manifiestos, el kubelet reinicia el componente con la nueva configuración. No lo hagas aquí: podrías dejar el clúster sin API server.

Pulsa **CHECK** cuando `estatico-node01` haya desaparecido.
