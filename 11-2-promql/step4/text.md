**kube-state-metrics** lee la API de Kubernetes y publica el estado de los objetos (`kube_*`). ¿Cuántos Pods hay en cada fase en todo el clúster?

`promql 'sum by (phase) (kube_pod_status_phase)'`{{exec}}

```text
{phase="Failed"}  0
{phase="Pending"}  0
{phase="Running"}  ...
{phase="Succeeded"}  ...
{phase="Unknown"}  0
```

Crea un Pod que pide 64 GiB de memoria. Ningún nodo los tiene, así que se quedará en `Pending`:

`kubectl apply -f /root/lab/pendiente.yaml`{{exec}}

`kubectl get pod pendiente -n lab-11`{{exec}}

`kubectl get events -n lab-11 --field-selector involvedObject.name=pendiente`{{exec}}

Espera unos 30 segundos (dos scrapes) y pregunta de nuevo. Esta es la condición de una alerta clásica:

`promql 'sum(kube_pod_status_phase{phase="Pending"}) > 0'`{{exec}}

`promql 'kube_pod_status_phase{namespace="lab-11", phase="Pending"} == 1'`{{exec}}

Ahora **node-exporter**, que mide el sistema operativo de cada nodo. Porcentaje de memoria disponible:

`promql 'round(100 * node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)'`{{exec}}

```text
{..., node="controlplane", ...}  ...
{..., node="node01", ...}  ...
```

**Qué observar**

- kube-state-metrics publica una serie por Pod y fase, con valor 1 o 0. Sumando obtienes cuántos Pods hay en cada fase.
- La alerta clásica es `sum(kube_pod_status_phase{phase="Pending"}) > 0` mantenida durante 10 minutos. El evento `FailedScheduling` te dice el porqué (`Insufficient memory`); la métrica, que pasa.
- La división entre dos métricas de node-exporter da un porcentaje por nodo. Aquí cada nodo es una máquina distinta, así que los valores pueden diferir; en el lab local del curso, con kind, los tres "nodos" daban lo mismo porque comparten la misma máquina.
- Los labels `node`, `namespace` o `pod` de cada serie los añaden las reglas de *relabeling* del job, a partir del service discovery.

Pulsa **CHECK** cuando Prometheus vea el Pod `pendiente` en `Pending`.
