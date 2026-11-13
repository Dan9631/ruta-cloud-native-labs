En tu máquina abrirías la interfaz con `kubectl port-forward` en `localhost`. Aquí el navegador está fuera del clúster, así que el port-forward debe escuchar en todas las interfaces (`--address 0.0.0.0`). Déjalo en segundo plano:

`kubectl port-forward --address 0.0.0.0 -n lab-11 svc/prometheus-server 9090:80 > /tmp/port-forward.log 2>&1 &`{{exec}}

`sleep 2; curl -s localhost:9090/-/ready; echo`{{exec}}

Abre la interfaz: **[Prometheus en el puerto 9090]({{TRAFFIC_HOST1_9090}})**. Ve a **Status → Target health**:

```text
kubernetes-api-servers         1/1 up
kubernetes-nodes               2/2 up
kubernetes-nodes-cadvisor      2/2 up
kubernetes-pods                ...
kubernetes-service-endpoints   .../... up
prometheus                     1/1 up
```

Si el enlace no carga, haz lo mismo desde la terminal. La interfaz web usa una API HTTP que también puedes llamar con `curl`. Los targets activos, contados por *scrape pool* (cada `job_name`):

`curl -s 'localhost:9090/api/v1/targets?state=active' | grep -oE '"scrapePool":"[^"]*"' | sort | uniq -c`{{exec}}

Y una consulta PromQL por la API: cuántos targets están arriba en cada job:

`curl -sG localhost:9090/api/v1/query --data-urlencode 'query=count by (job) (up)'; echo`{{exec}}

La respuesta es JSON. Para leerla mejor tienes el comando `promql`, que hace la misma llamada por el proxy del apiserver (sin port-forward) y muestra una línea por serie:

`promql 'count by (job) (up)'`{{exec}}

```text
{job="kubernetes-api-servers"}  1
{job="kubernetes-nodes"}  2
{job="kubernetes-nodes-cadvisor"}  2
{job="kubernetes-service-endpoints"}  ...
{job="prometheus"}  1
...
```

Si tienes curiosidad, `cat /usr/local/bin/promql`{{exec}} muestra cómo lo hace.

**Qué observar**

- Nadie escribió esos targets a mano: los encontró el **service discovery** de Kubernetes.
- `kubernetes-service-endpoints` incluye kube-state-metrics y los 2 node-exporters (sus Services llevan anotaciones de Prometheus), y puede incluir otros Services anotados, como el DNS del clúster.
- `kubernetes-nodes-cadvisor` son los cAdvisor de los 2 kubelets: uno por nodo (en el lab local del curso, 3).
- En `kubernetes-pods` aparecen los Pods con la anotación `prometheus.io/scrape: "true"`. Puede estar vacío: en el reto meterás uno.

Pulsa **CHECK** con el port-forward funcionando.
