Detén el CronJob para que deje de crear Jobs:

`kubectl delete cronjob reporte -n lab-03`{{exec}}

Hasta ahora has usado `-n lab-03` en cada comando. Mira qué hay en el resto del clúster:

`kubectl get ns`{{exec}}

`kubectl get deploy -A`{{exec}}

`kubectl get ds -A`{{exec}}

`kubectl get sts -A`{{exec}}

**Qué observar**

- `-A` (`--all-namespaces`) recorre todos los namespaces.
- En `kube-system` viven los componentes del propio clúster. `coredns` es un Deployment.
- Los DaemonSets del sistema, como `kube-proxy`, tienen DESIRED = 2 porque hay 2 nodos: un DaemonSet pone un Pod en cada nodo.
- Lo normal es que no haya ningún StatefulSet todavía. Se usan para aplicaciones con estado y los verás en el módulo de almacenamiento.

Este paso no tiene comprobación. Pulsa **NEXT** para terminar.
