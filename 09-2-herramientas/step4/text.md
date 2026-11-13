El kubelet no es un Pod: es un **servicio systemd** en cada nodo. Para verlo hay que ir al nodo. Las aplicaciones de `lab-09` corren en `node01`, y desde `controlplane` se entra por SSH sin contraseña:

`ssh node01 systemctl status kubelet --no-pager | head -5`{{exec}}

```text
● kubelet.service - kubelet: The Kubernetes Node Agent
     Loaded: loaded (/usr/lib/systemd/system/kubelet.service; enabled; preset: enabled)
     Active: active (running) since ...
```

El kubelet escribe en **journald**. Busca en su registro el fallo de `reporter`:

`ssh node01 journalctl -u kubelet --no-pager | grep reporter-config | tail -2`{{exec}}

```text
kubelet[...]: E1023 ... "Error syncing pod, skipping" err="failed to \"StartContainer\" for \"reporter\" with
CreateContainerConfigError: \"configmap \\\"reporter-config\\\" not found\"" pod="lab-09/reporter-..."
```

Hay una alternativa 100 % Kubernetes, sin SSH: un **Pod de depuración de nodo**. Corre en los namespaces de red, PID e IPC del nodo, con su sistema de archivos montado en `/host`. Por defecto no es privilegiado, así que pide el perfil `sysadmin`:

`kubectl debug node/node01 -n lab-09 -it --image=busybox:1.37 --profile=sysadmin`{{exec}}

Dentro, entra en el sistema de archivos del nodo y lista sus contenedores con `crictl`:

`chroot /host`{{exec}}

`crictl ps | head -5`{{exec}}

Sal dos veces: la primera del `chroot`, la segunda del Pod de depuración:

`exit`{{exec}}

`exit`{{exec}}

El Pod de depuración queda en `lab-09`:

`kubectl get pods -n lab-09 -o wide | grep node-debugger`{{exec}}

**Qué observar**

- El kubelet registra los mismos errores que ves en los eventos, desde el lado del nodo.
- `crictl` habla directamente con el runtime de contenedores (containerd) por **CRI**: ves todos los contenedores del nodo, de todos los namespaces.
- Si el kubelet de un nodo cae, el nodo pasa a `NotReady` y, tras unos 5 minutos, sus Pods se reprograman en otros nodos (toleration `node.kubernetes.io/unreachable` de 300 s). Aquí no lo probamos: con un solo nodo de trabajo, las aplicaciones no tendrían adónde ir.
- En el curso el clúster es de kind y cada nodo es un contenedor de Podman: allí `podman exec` hace el papel de `ssh`.

Pulsa **CHECK**.
