# Segunda parte terminada

Has visto que:

- la QoS class se deduce de requests y limits, y el scheduler reserva según los requests, no según el consumo real,
- un LimitRange pone valores por defecto y máximos por contenedor; una ResourceQuota pone techo al namespace entero,
- un DaemonSet pone un Pod en cada nodo que pueda tolerar sus taints,
- un static Pod lo arranca el kubelet desde un archivo, sin scheduler, y solo desaparece al borrar el archivo,
- un Pod con un `schedulerName` que nadie atiende queda `Pending` sin eventos,
- una PriorityClass se traduce en un número que ordena la cola del scheduler,
- `topologySpreadConstraints` reparte réplicas entre zonas con una diferencia máxima.

Ya puedes intentar el **Módulo 04 (3 de 3) · Reto**.

El clúster de esta sesión se borra al cerrar, así que no hace falta limpiar nada.
