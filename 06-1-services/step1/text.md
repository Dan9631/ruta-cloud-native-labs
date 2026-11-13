En un clúster hay tres redes distintas: la de los nodos, la de los Pods y la de los Services. Empieza por las dos primeras.

`kubectl get nodes -o custom-columns='NODO:.metadata.name,POD_CIDR:.spec.podCIDR,IP:.status.addresses[0].address'`{{exec}}

La columna `IP` es la dirección del nodo en la red de nodos. `POD_CIDR` es el rango del que salen las IPs de los Pods de ese nodo (si aparece `<none>`, el plugin de red reparte las IPs por su cuenta sin usar ese campo).

Busca ahora los componentes de red. Los DaemonSets ponen un Pod en cada nodo:

`kubectl get ds -A`{{exec}}

`kubectl get pods -n kube-system -o wide | grep -E 'kube-proxy|coredns'`{{exec}}

Uno de los DaemonSets es el **CNI**, el plugin que da IP y red a cada Pod. En el clúster local del curso es `kindnet`; aquí el nombre depende del entorno (por ejemplo `canal`, `flannel` o `cilium`). El otro es `kube-proxy`.

¿En qué modo trabaja kube-proxy?

`kubectl get cm kube-proxy -n kube-system -o jsonpath='{.data.config\.conf}' | grep -E '^mode'`{{exec}}

Si sale `mode: ""` o `mode: iptables`, kube-proxy usa iptables: con el valor vacío toma el modo por defecto, que en Linux sigue siendo iptables.

Estás en el propio nodo `controlplane`, así que puedes leer la configuración CNI directamente:

`ls /etc/cni/net.d/`{{exec}}

`head -n 30 /etc/cni/net.d/*.conflist`{{exec}}

**Qué observar**

- Cada nodo tiene su propio rango de IPs de Pods.
- El CNI y `kube-proxy` corren en **todos** los nodos: son DaemonSets, con DESIRED = 2 porque hay 2 nodos.
- La configuración CNI es justo lo que describe la especificación: un archivo JSON en `/etc/cni/net.d` que nombra los plugins que se encadenan (uno crea la interfaz del Pod, otro reparte las IPs, que es el IPAM).

Este paso no tiene comprobación. Pulsa **NEXT**.
