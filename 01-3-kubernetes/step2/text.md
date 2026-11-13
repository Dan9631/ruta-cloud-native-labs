Lee el manifiesto del Pod. Fíjate en el nombre completo de la imagen y en `imagePullPolicy`:

`cat /root/lab/pod-web-propia.yaml`{{exec}}

Créalo y míralo:

`kubectl apply -f /root/lab/pod-web-propia.yaml`{{exec}}

`kubectl wait --for=condition=Ready pod/web-propia -n lab-01 --timeout=60s`{{exec}}

`kubectl get pod web-propia -n lab-01 -o wide --show-labels`{{exec}}

`kubectl exec web-propia -n lab-01 -- wget -qO- http://localhost/`{{exec}}

```text
NAME         READY   STATUS    RESTARTS   AGE   IP      NODE           ...   LABELS
web-propia   1/1     Running   0          11s   ...     controlplane   ...   app=kcna-web,version=v1
...
  <h1>Hola desde mi imagen KCNA v1</h1>
...
```

Mira en los eventos si el kubelet descargó algo:

`kubectl describe pod web-propia -n lab-01 | grep -E 'Pulled|Created|Started'`{{exec}}

```text
  Normal  Pulled   24s  kubelet  ... Container image "localhost/kcna-web:1.0" already present on machine ...
  Normal  Created  24s  kubelet  ... Container created
  Normal  Started  23s  kubelet  ... Container started
```

Ahora baja un nivel y mira el mismo contenedor desde el runtime del nodo:

`crictl pods --namespace lab-01`{{exec}}

`crictl ps --name web`{{exec}}

```text
CONTAINER       IMAGE           CREATED              STATE     NAME   ATTEMPT   POD ID          POD          NAMESPACE
0cbbf58ecb4e7   d102d05786612   About a minute ago   Running   web    0         d3b17e36fbc15   web-propia   lab-01
```

**Qué observar**

- *already present on machine*: el kubelet no descargó nada porque la imagen tiene tag fijo, `imagePullPolicy` es `IfNotPresent` y ya estaba en el nodo.
- La **misma imagen** corre igual en Podman y en Kubernetes: eso es el estándar OCI.
- Debajo de Kubernetes hay un runtime normal (containerd + runc) ejecutando un contenedor con el ID de tu imagen.
- En un clúster de varios nodos tendrías que importar la imagen en el nodo donde cae el Pod (o en todos). Aquí solo hay uno.

Pulsa **CHECK** con el Pod `Running`.
