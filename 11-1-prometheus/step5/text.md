El chart generó la configuración de Prometheus (`prometheus.yml`) en un ConfigMap. Mira sus jobs y sus intervalos:

`kubectl get configmap prometheus-server -n lab-11 -o jsonpath='{.data.prometheus\.yml}' | grep -E 'job_name|scrape_interval'`{{exec}}

```text
  scrape_interval: 15s
- job_name: kubernetes-api-servers
- job_name: kubernetes-nodes
- job_name: kubernetes-nodes-cadvisor
- job_name: kubernetes-pods
- job_name: kubernetes-pods-slow
  scrape_interval: 5m
- job_name: kubernetes-service-endpoints
...
- job_name: prometheus
```

Busca la regla que decide qué Pods se scrapean:

`kubectl get configmap prometheus-server -n lab-11 -o jsonpath='{.data.prometheus\.yml}' | grep -B2 -A3 '__meta_kubernetes_pod_annotation_prometheus_io_scrape$'`{{exec}}

Lo que Prometheus scrapea es texto plano. Léelo tú a través del proxy del apiserver, sin port-forward:

`kubectl get --raw /api/v1/namespaces/lab-11/services/prometheus-prometheus-node-exporter:9100/proxy/metrics | grep -E '^# TYPE node_load1|^node_load1 |^# TYPE node_cpu_seconds_total'`{{exec}}

```text
# TYPE node_cpu_seconds_total counter
# TYPE node_load1 gauge
node_load1 0.42
```

Por último, Helm guarda lo que instaló. Mira tus valores y lo que el chart creó **fuera** del namespace:

`helm get values prometheus -n lab-11`{{exec}}

`kubectl get clusterrole,clusterrolebinding | grep prometheus`{{exec}}

**Qué observar**

- Cada `job_name` es un bloque de `scrape_configs`. El global de 15 s es el de los valores; sin indicarlo, Prometheus usa 1 minuto.
- La regla con `__meta_kubernetes_pod_annotation_prometheus_io_scrape` y `action: keep` hace que solo se scrapeen los Pods con la anotación `prometheus.io/scrape: "true"`. Es una **convención** de esta configuración, no una API de Kubernetes. La usarás en el reto.
- El formato de exposición declara el **tipo**: `node_cpu_seconds_total` es un **counter** (segundos acumulados de CPU) y `node_load1` un **gauge**. Tu valor de `node_load1` será otro.
- Los ClusterRoles y ClusterRoleBindings no pertenecen a `lab-11`: borrar el namespace no los borra. Por eso se limpia con `helm uninstall prometheus -n lab-11`.

Este paso no tiene comprobación. Pulsa **NEXT** para terminar.
