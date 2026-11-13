# Recursos, DaemonSets y prioridad

Este escenario es la segunda parte del laboratorio del módulo 04 de **Ruta Cloud Native**. Trabajas en un clúster real de Kubernetes con dos nodos: `controlplane` y `node01`. No necesitas haber hecho la primera parte.

En unos 40 minutos vas a:

- ver cómo requests y limits deciden la QoS class de un Pod,
- poner valores por defecto y techos con LimitRange y ResourceQuota,
- desplegar un DaemonSet y ver cómo le afectan los taints,
- crear un static Pod que no pasa por el scheduler,
- dejar un Pod sin scheduler y dar prioridad a otro,
- repartir réplicas por zonas.

**Diferencia con el lab local del curso.** Allí hay un plano de control con taint y dos workers. Aquí solo hay dos nodos, así que al arrancar el escenario se ha preparado esto:

- se ha quitado el taint de control-plane de `controlplane`, para que también acepte Pods,
- `controlplane` lleva las labels `disktype=ssd` y `zone=zona-a`,
- `node01` lleva `disktype=hdd` y `zone=zona-b`.

El arranque también instala metrics-server para `kubectl top`. Puede tardar un par de minutos más en responder; solo lo usa un comando opcional.

El clúster tiene unos 4 GB de memoria en total, así que todos los Pods del lab piden muy poco (10–50m de CPU y 16–64Mi de memoria).

Todo se hace en el namespace `lab-04`. Los manifiestos están en `/root/lab`.

Cómo usarlo:

- Haz clic en un comando para ejecutarlo en la terminal.
- Al final de cada paso pulsa **CHECK**: el escenario comprueba el estado del clúster antes de dejarte avanzar.
- La sesión dura como máximo una hora y el clúster se borra al terminar.

Espera a que la terminal muestre los dos nodos con sus labels y pulsa **START**.
