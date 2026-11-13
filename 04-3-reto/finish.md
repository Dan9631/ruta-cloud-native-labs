# Reto superado

Has colocado cada carga con la herramienta adecuada:

- un taint en `node01` y un Pod que lo tolera **y** lo exige por label: un nodo dedicado de verdad,
- un Deployment fijado al nodo `disktype=ssd` con requests iguales a limits, es decir, QoS Guaranteed,
- un DaemonSet que llega a todos los nodos porque tolera los taints que hay en ellos,
- una ResourceQuota que pone techo al namespace.

Con esto termina el laboratorio del módulo 04 de **Ruta Cloud Native**. Vuelve al curso para hacer el examen del módulo.
