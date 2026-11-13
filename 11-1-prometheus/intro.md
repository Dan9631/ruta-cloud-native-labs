# Logs, kubectl top e instalar Prometheus

Este escenario es la primera parte del laboratorio del módulo 11 (observabilidad) de **Ruta Cloud Native**. Trabajas en un clúster real de Kubernetes con dos nodos: `controlplane` y `node01`.

En unos 40 minutos vas a:

- leer los logs y los eventos de un Pod, y ver dónde se guardan en el nodo,
- mirar el consumo actual de nodos y Pods con `kubectl top` (metrics-server),
- revisar el chart de Prometheus y sus valores antes de instalarlo,
- instalar un Prometheus ligero con Helm (sin Alertmanager ni Pushgateway, sin disco persistente), con **kube-state-metrics** y **node-exporter**,
- abrir su interfaz web y ver los targets que descubrió solo,
- leer la configuración que generó el chart y las métricas en crudo de un exporter.

Todo se hace en el namespace `lab-11`, que se crea solo al arrancar. Los manifiestos y los valores del chart están en `/root/lab`. Al arrancar también se instalan `helm` y metrics-server si el clúster no los trae.

Cómo usarlo:

- Haz clic en un comando para ejecutarlo en la terminal.
- Al final de cada paso pulsa **CHECK**: el escenario comprueba el estado del clúster antes de dejarte avanzar.
- La sesión dura como máximo una hora y el clúster se borra al terminar.

Espera a que la terminal muestre los dos nodos y pulsa **START**.
