# Consultas PromQL

Este escenario es la segunda parte del laboratorio del módulo 11 (observabilidad) de **Ruta Cloud Native**. Trabajas en un clúster real de Kubernetes con dos nodos: `controlplane` y `node01`.

Al arrancar se instala solo el mismo Prometheus ligero que montaste a mano en la primera parte: chart `prometheus-community/prometheus` 29.37.2 en el namespace `lab-11`, con **kube-state-metrics** y **node-exporter**, sin Alertmanager ni Pushgateway. Tarda unos minutos: la terminal te avisa cuando está listo.

En unos 30 minutos vas a:

- abrir la interfaz web de Prometheus y llamar a su API con `curl`,
- consultar qué targets están arriba y filtrar con selectores de labels,
- usar `rate()` con un counter y leer un gauge,
- consultar el estado de los objetos (kube-state-metrics) y de los nodos (node-exporter),
- comparar la memoria que piden los Pods con la que usan de verdad.

Cada consulta puedes hacerla en la interfaz web o en la terminal con el comando `promql`, que llama a la misma API y no depende del navegador.

Cómo usarlo:

- Haz clic en un comando para ejecutarlo en la terminal.
- Cuando un paso tiene comprobación, pulsa **CHECK** al final; si no la tiene, pulsa **NEXT**.
- La sesión dura como máximo una hora y el clúster se borra al terminar.

Espera a que la terminal muestre los Pods de Prometheus y pulsa **START**.
