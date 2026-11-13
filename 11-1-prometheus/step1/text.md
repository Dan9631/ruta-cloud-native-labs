Antes de instalar nada, mira la observabilidad "de serie" que trae Kubernetes: logs, eventos y el consumo actual.

Crea un Pod que escribe logs: `INFO` por la salida estándar (stdout) y, de vez en cuando, `ERROR` por la salida de errores (stderr):

`cat /root/lab/01-registro.yaml`{{exec}}

`kubectl apply -f /root/lab/01-registro.yaml`{{exec}}

`kubectl get pod registro -n lab-11 -o wide`{{exec}}

Cuando esté `Running`, lee sus logs:

`kubectl logs registro -n lab-11 --tail=6`{{exec}}

```text
10:41:02 INFO pedido 9 procesado
10:41:04 INFO pedido 10 procesado
10:41:04 ERROR pago rechazado id=10
10:41:06 INFO pedido 11 procesado
...
```

`kubectl logs registro -n lab-11 | grep ERROR`{{exec}}

`kubectl logs registro -n lab-11 --timestamps --tail=3`{{exec}}

El runtime guarda esos logs en archivos del nodo donde corre el Pod (aquí, `node01`):

`ssh node01 'ls /var/log/pods | grep registro; ls -l /var/log/containers | grep registro'`{{exec}}

Ahora los eventos del namespace, de más antiguo a más reciente:

`kubectl get events -n lab-11 --sort-by=.lastTimestamp`{{exec}}

Por último, el consumo actual según metrics-server. Si dice `metrics not available yet`, espera un minuto y repite:

`kubectl top nodes`{{exec}}

`kubectl top pods -A --sort-by=cpu`{{exec}}

```text
NAME           CPU(cores)   CPU(%)   MEMORY(bytes)   MEMORY(%)
controlplane   ...
node01         ...
```

**Qué observar**

- La app solo escribe en stdout y stderr; `kubectl logs` muestra las dos salidas. No tiene que saber nada de archivos ni de backends.
- Los logs viven en el nodo (`/var/log/pods/...`, enlazados en `/var/log/containers/`) y el kubelet los rota. Si el Pod se borra o el nodo muere, desaparecen: Kubernetes **no trae** logging a nivel de clúster. Para eso se monta un agente por nodo (DaemonSet), como Fluent Bit, que los envía a un backend (Loki, Elasticsearch...).
- Los eventos (`Scheduled`, `Pulled`, `Started`...) cuentan los cambios de estado de los objetos. Son otra señal, y también caducan.
- `kubectl top` da solo CPU y memoria **actuales**, sin historial ni lenguaje de consultas. Lo sirve metrics-server a través de la Metrics API, la misma que usa el HPA. Para historia, consultas y alertas hace falta Prometheus.

Pulsa **CHECK** cuando el Pod esté `Running` y `kubectl top nodes` muestre los dos nodos.
