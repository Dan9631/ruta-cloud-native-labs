Borra el Pod del paso anterior:

`kubectl delete pod pendiente -n lab-11 --now`{{exec}}

En Kubernetes, lo que "ocupa" un nodo son los `requests`, no el uso real. Compara las dos cosas para los Pods de `lab-11`. Primero, la memoria que **piden** (en MiB), según kube-state-metrics:

`promql 'sum by (pod) (kube_pod_container_resource_requests{namespace="lab-11", resource="memory"}) / 1024 / 1024'`{{exec}}

Después, la que **usan** de verdad, según cAdvisor:

`promql 'sum by (pod) (container_memory_working_set_bytes{namespace="lab-11", container!=""}) / 1024 / 1024'`{{exec}}

Los requests salen de los valores del chart:

```text
pod                                  requests (MiB)
prometheus-server-...                     256
prometheus-kube-state-metrics-...          32
prometheus-prometheus-node-exporter-...    16   (x2)
```

Compara cada fila con su uso real. También puedes calcular la diferencia en una sola consulta (positiva: pide de más; negativa: usa más de lo que pide):

`promql 'sum by (pod) (kube_pod_container_resource_requests{namespace="lab-11", resource="memory"}) / 1024 / 1024 - sum by (pod) (container_memory_working_set_bytes{namespace="lab-11", container!=""}) / 1024 / 1024'`{{exec}}

**Qué observar**

- Si un Pod usa **más** memoria de la que pide (en el lab local del curso le pasaba al servidor de Prometheus), el scheduler podría colocarlo en un nodo sin espacio real: riesgo de presión de memoria y desalojos.
- Si pide mucho **más** de lo que usa (en el curso, node-exporter pedía casi el doble), estás reservando y pagando capacidad que nadie usa.
- Esa comparación, hecha para todo el clúster y durante días, es la base del *right-sizing* y de herramientas como OpenCost o el VPA en modo recomendación.
- La resta funciona porque las dos expresiones tienen los mismos labels (`pod`): PromQL empareja las series por sus labels.

Este paso no tiene comprobación. Pulsa **NEXT** para terminar.
