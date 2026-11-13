# Reto superado

Has hecho que Prometheus descubra una app nueva sin tocar su configuración:

- las anotaciones `prometheus.io/scrape`, `port` y `path` en los **Pods** (no en el Deployment) activan el job `kubernetes-pods` del chart,
- el service discovery encontró las 2 réplicas y cada una es un target con su propio `up`,
- los labels del Pod (`app`, `pod_template_hash`) y `namespace`, `pod` y `node` se añadieron solos a cada serie, gracias al *relabeling*,
- `tienda_pedidos_total` es un counter y se consulta con `rate()`; `tienda_carrito_items` es un gauge y se promedia directamente.

Recuerda que esas anotaciones son una convención de esta configuración, no una API de Kubernetes. Con el Prometheus Operator (chart `kube-prometheus-stack`) harías lo mismo con un `PodMonitor` o un `ServiceMonitor`.

Con esto termina el laboratorio del módulo 11 de **Ruta Cloud Native**. Vuelve al curso para hacer el examen del módulo.
