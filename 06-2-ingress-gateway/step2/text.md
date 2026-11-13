Con Gateway API los roles se separan: el proveedor define la GatewayClass, el operador del clúster crea el Gateway y tú solo creas la ruta. Mira las dos primeras piezas:

`kubectl get gatewayclass`{{exec}}

`kubectl get gateway -n traefik`{{exec}}

```text
NAME      CONTROLLER                      ACCEPTED   AGE
traefik   traefik.io/gateway-controller   True       43m

NAME              CLASS     ADDRESS   PROGRAMMED   AGE
traefik-gateway   traefik             True         43m
```

Crea tu HTTPRoute en `lab-06`, colgada del Gateway del namespace `traefik`:

`cat /root/lab/06-httproute.yaml`{{exec}}

`kubectl apply -f /root/lab/06-httproute.yaml`{{exec}}

`kubectl get httproute -n lab-06`{{exec}}

`kubectl get httproute whoami -n lab-06 -o jsonpath='{range .status.parents[0].conditions[*]}{.type}={.status} {end}'; echo`{{exec}}

```text
Accepted=True ResolvedRefs=True
```

Pruébala por el mismo NodePort de Traefik:

`CP=$(kubectl get node controlplane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}'); for i in 1 2 3; do curl -s http://$CP:30800/lab06/gateway | grep Hostname; done`{{exec}}

```text
Hostname: whoami-6bb7cb8689-rlrjv
Hostname: whoami-6bb7cb8689-hr2rj
Hostname: whoami-6bb7cb8689-6kg4c
```

En el navegador: [whoami por la HTTPRoute]({{TRAFFIC_HOST1_30800}}/lab06/gateway).

**Qué observar**

- La ruta vive en **tu** namespace (`lab-06`) pero se engancha (`parentRefs`) a un Gateway de **otro** namespace (`traefik`), que lo permite con `allowedRoutes.namespaces.from: All`.
- `Accepted=True` significa que el Gateway aceptó la ruta; `ResolvedRefs=True`, que el Service de destino existe.
- La columna `ADDRESS` del Gateway puede salir vacía: aquí Traefik no tiene una IP de balanceador que anunciar.

Pulsa **CHECK**.
