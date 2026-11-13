Mira cómo resuelve nombres un Pod. El kubelet escribe su `/etc/resolv.conf`:

`kubectl exec -n lab-06 cliente -- cat /etc/resolv.conf`{{exec}}

```text
search lab-06.svc.cluster.local svc.cluster.local cluster.local ...
nameserver 10.96.0.10
options ndots:5
```

Comprueba que ese `nameserver` es la IP del Service `kube-dns`, detrás del que corre CoreDNS:

`kubectl get svc kube-dns -n kube-system`{{exec}}

Resuelve el nombre completo del Service:

`kubectl exec -n lab-06 cliente -- nslookup whoami.lab-06.svc.cluster.local`{{exec}}

```text
Server:    10.96.0.10
Address:   10.96.0.10:53

Name:   whoami.lab-06.svc.cluster.local
Address: 10.96.29.208
```

Prueba ahora el nombre corto:

`kubectl exec -n lab-06 cliente -- nslookup whoami`{{exec}}

```text
** server can't find whoami.svc.cluster.local: NXDOMAIN
Name:   whoami.lab-06.svc.cluster.local
Address: 10.96.29.208
** server can't find whoami.cluster.local: NXDOMAIN
...
```

Por último, pide la página 6 veces desde el cliente. Cada `wget` abre una conexión nueva:

`kubectl exec -n lab-06 cliente -- sh -c 'for i in 1 2 3 4 5 6; do wget -qO- http://whoami | grep Hostname; done'`{{exec}}

```text
Hostname: whoami-6bb7cb8689-6kg4c
Hostname: whoami-6bb7cb8689-rlrjv
Hostname: whoami-6bb7cb8689-rlrjv
Hostname: whoami-6bb7cb8689-6kg4c
Hostname: whoami-6bb7cb8689-6kg4c
Hostname: whoami-6bb7cb8689-hr2rj
```

**Qué observar**

- `nameserver` es la IP del Service `kube-dns` (CoreDNS) y el nombre completo resuelve a la ClusterIP.
- Al final del `search` pueden aparecer dominios heredados del nodo: el kubelet los copia de su `/etc/resolv.conf`.
- El `nslookup` de busybox prueba **todos** los dominios del `search` (efecto de `ndots:5`) y muestra un NXDOMAIN por cada intento fallido, pero el que importa (`whoami.lab-06.svc.cluster.local`) responde. Por eso dentro del mismo namespace basta con `whoami`; desde otro namespace hay que escribir al menos `whoami.lab-06`.
- Con conexiones nuevas, kube-proxy elige un Pod **al azar** en cada una: no es round-robin estricto. Los nombres que veas serán otros.

Este paso no tiene comprobación. Pulsa **NEXT**.
