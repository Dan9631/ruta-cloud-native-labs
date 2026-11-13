Ya no necesitas el Pod del sidecar. Bórralo para liberar memoria; al borrarlo, el kubelet detiene primero nginx y después el sidecar:

`kubectl delete pod web-con-sidecar -n lab-07`{{exec}}

Pasas a la segunda pieza: la división de tráfico. Traefik ya está instalado como controlador de Gateway API. Mira la GatewayClass y el Gateway que creó al arrancar:

`kubectl get gatewayclass`{{exec}}

`kubectl get gateway -n traefik`{{exec}}

```text
NAME      CONTROLLER                      ACCEPTED   AGE
traefik   traefik.io/gateway-controller   True       5m

NAME              CLASS     ADDRESS   PROGRAMMED   AGE
traefik-gateway   traefik   ...       True         5m
```

El Gateway escucha en el puerto 30080 de los nodos. Guarda su URL en una variable para los pasos siguientes (en una terminal nueva ya viene definida):

`export GW=http://$(kubectl get node controlplane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}'):30080; echo $GW`{{exec}}

Despliega las dos versiones del microservicio:

`cat /root/lab/02-whoami-v1-v2.yaml`{{exec}}

`kubectl apply -f /root/lab/02-whoami-v1-v2.yaml`{{exec}}

`kubectl rollout status deploy/whoami-v1 -n lab-07`{{exec}}

`kubectl rollout status deploy/whoami-v2 -n lab-07`{{exec}}

`kubectl get deploy,svc -n lab-07`{{exec}}

```text
NAME                        READY   UP-TO-DATE   AVAILABLE
deployment.apps/whoami-v1   2/2     2            2
deployment.apps/whoami-v2   1/1     1            1

NAME                TYPE        CLUSTER-IP     PORT(S)
service/whoami-v1   ClusterIP   10.x.x.x       80/TCP
service/whoami-v2   ClusterIP   10.x.x.x       80/TCP
```

**Qué observar**

- v1 tiene 2 réplicas y v2 solo 1.
- Cada versión tiene su propio Service.
- La variable `WHOAMI_NAME` hace que cada una se identifique en la respuesta (`Name: v1` / `Name: v2`).

Pulsa **CHECK**.
