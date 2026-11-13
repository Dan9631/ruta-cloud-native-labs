La tienda del equipo de ventas ya expone métricas, pero nadie las ve. En el namespace `lab-11`:

1. Despliega `/root/lab/02-tienda.yaml` y comprueba que la app sirve métricas en el puerto `8080`, ruta `/metrics.txt`.
2. Comprueba que Prometheus **no** la está scrapeando.
3. Modifica el Deployment `tienda` para que Prometheus la descubra con las anotaciones de la convención (`scrape`, `port` y `path`) **en los Pods**, y escálalo a **2 réplicas**.
4. Calcula con PromQL los pedidos por segundo por método de pago, con `rate()` sobre `tienda_pedidos_total`, y el promedio de `tienda_carrito_items`.

El CHECK verifica: Prometheus en `lab-11`, kube-state-metrics y node-exporter scrapeados, `tienda` con 2 réplicas listas y las 3 anotaciones, 2 targets de `tienda` con `up == 1` y que `tienda_pedidos_total` crece. Tras aplicar el cambio, espera ~1 minuto antes de pulsarlo (descubrimiento + 2 scrapes).

**Pistas**

- Para ver las métricas desde dentro del Pod: `kubectl exec -n lab-11 deploy/tienda -- wget -qO- localhost:8080/metrics.txt`{{copy}}
- La regla que decide qué Pods se scrapean está en la configuración que generó el chart: `kubectl get configmap prometheus-server -n lab-11 -o jsonpath='{.data.prometheus\.yml}' | grep -A3 'prometheus_io_'`{{copy}}
- Las anotaciones del Pod viven en `spec.template.metadata`, no en el `metadata` del Deployment: `kubectl explain deployment.spec.template.metadata.annotations`{{copy}}
- Para consultar desde la terminal: `promql 'up{app="tienda"}'`{{copy}}
- Para la interfaz web, abre un port-forward en segundo plano y entra por **[el puerto 9090]({{TRAFFIC_HOST1_9090}})** (**Status → Target health** y **Query**): `kubectl port-forward --address 0.0.0.0 -n lab-11 svc/prometheus-server 9090:80 > /tmp/port-forward.log 2>&1 &`{{copy}}

Cuando creas que está, pulsa **CHECK**.

**Si te atascas**

Hay una solución completa en `/root/solucion`. Inténtalo antes de mirarla:

`cat /root/solucion/pasos.txt`{{copy}}
