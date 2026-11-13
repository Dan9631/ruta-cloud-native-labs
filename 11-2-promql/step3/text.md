cAdvisor, dentro del kubelet, mide cada contenedor. `container_cpu_usage_seconds_total` es un **counter**: segundos de CPU acumulados desde que arrancó el contenedor. Mira sus valores crudos:

`promql 'container_cpu_usage_seconds_total{namespace="lab-11", container!=""}'`{{exec}}

Ese número solo sube y no dice nada por sí solo. Con `rate()` obtienes el ritmo por segundo, promediado en una ventana de 2 minutos, y lo sumas por Pod:

`promql 'sum by (pod) (rate(container_cpu_usage_seconds_total{namespace="lab-11", container!=""}[2m]))'`{{exec}}

```text
{pod="prometheus-server-xxxxxxxxxx-xxxxx"}  0.075
{pod="prometheus-prometheus-node-exporter-xxxxx"}  0.012
{pod="prometheus-kube-state-metrics-xxxxxxxxxx-xxxxx"}  0.008
...
```

Tus números serán distintos. En la interfaz web, pulsa **Graph** con esta consulta para ver la evolución.

La memoria en uso, en cambio, es un **gauge**: sube y baja, y se lee directamente. Súmala por namespace y pásala a MiB:

`promql 'sum by (namespace) (container_memory_working_set_bytes{container!=""}) / 1024 / 1024'`{{exec}}

```text
{namespace="kube-system"}  ...
{namespace="lab-11"}  ...
...
```

**Qué observar**

- El resultado de `rate()` está en **núcleos**: 0.075 son 75m de CPU.
- `container!=""` descarta la serie agregada del Pod completo que también publica cAdvisor. Sin ese filtro contarías dos veces.
- Sin `rate()` verías segundos acumulados desde el arranque. Un counter se consulta siempre con `rate()` o `increase()`; un gauge, con su valor directo, `avg` o `max`.
- `container_memory_working_set_bytes` es la misma métrica (*working set*) que usa `kubectl top` y la base de la señal `memory.available` con la que el kubelet decide los desalojos por presión de memoria.

Este paso no tiene comprobación. Pulsa **NEXT**.
