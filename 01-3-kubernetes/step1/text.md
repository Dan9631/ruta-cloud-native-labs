Construye la imagen con Podman, como en la parte anterior:

`cd /root/lab && podman build -t kcna-web:1.0 .`{{exec}}

`podman images kcna-web`{{exec}}

```text
REPOSITORY          TAG   IMAGE ID      CREATED        SIZE
localhost/kcna-web  1.0   d102d0578661  5 seconds ago  49.7 MB
```

El kubelet no habla con Podman: habla con **containerd** por CRI. Pregunta a containerd con `crictl`:

`crictl images | grep kcna || echo "containerd no tiene ninguna imagen kcna"`{{exec}}

```text
containerd no tiene ninguna imagen kcna
```

Cada runtime tiene su propio almacén de imágenes. Exporta la imagen de Podman a un archivo e impórtala en containerd, en el namespace `k8s.io`, que es el que usa el kubelet:

`podman save -o /root/kcna-web-1.0.tar localhost/kcna-web:1.0`{{exec}}

`ctr -n k8s.io images import /root/kcna-web-1.0.tar`{{exec}}

`crictl images | grep kcna`{{exec}}

```text
unpacking localhost/kcna-web:1.0 (sha256:...)...done
localhost/kcna-web     1.0     d102d05786612     49.7MB
```

**Qué observar**

- La imagen estaba en el nodo, pero en el almacén de Podman; containerd no la veía hasta importarla.
- `podman save` + `ctr images import` es lo mismo que hace un clúster local como kind cuando "carga" una imagen (`kind load`): exportar e importar en el containerd de cada nodo.
- `crictl` es la herramienta para hablar con el runtime CRI del nodo; `ctr` es la CLI de bajo nivel de containerd.
- En un clúster real no se hace así: harías `podman push` a un registry y los nodos la descargarían.

Pulsa **CHECK** cuando `crictl images` muestre `localhost/kcna-web`.
