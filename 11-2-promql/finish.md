# Segunda parte terminada

Has consultado un Prometheus real con PromQL:

- `up` y `count by (job) (up)` te dicen qué targets responden; `up == 0` filtra los caídos,
- los selectores `{label="x"}`, `!=`, `=~` y `!~` eligen las series,
- un **counter** se consulta con `rate()` (el resultado de CPU está en núcleos) y un **gauge** se lee directamente,
- kube-state-metrics da el estado de los objetos (`kube_pod_status_phase`) y node-exporter el del sistema operativo de cada nodo,
- comparar `requests` con el uso real es el primer paso del right-sizing.

La interfaz web, `curl` y el comando `promql` usan la misma API HTTP de Prometheus.

El clúster de esta sesión se borra al cerrar, así que no hace falta limpiar nada. Falta el reto, donde harás que Prometheus descubra una app nueva: **Módulo 11 (3 de 3) · Reto**.
