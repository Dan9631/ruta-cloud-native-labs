# Dónde cae cada Pod

Este escenario es la primera parte del laboratorio del módulo 04 de **Ruta Cloud Native**. Trabajas en un clúster real de Kubernetes con dos nodos: `controlplane` y `node01`.

En unos 35 minutos vas a:

- ver cómo reparte Pods el scheduler y cómo saltártelo con `nodeName`,
- filtrar Pods y nodos con selectors,
- dirigir Pods con `nodeSelector` y node affinity, y diagnosticar un Pod `Pending`,
- separar réplicas con pod anti-affinity,
- reservar un nodo con taints, tolerations y afinidad.

**Diferencia con el lab local del curso.** Allí hay tres nodos: un plano de control con taint, donde no cae ningún Pod, y dos workers. Aquí solo hay dos nodos, así que al arrancar el escenario se ha preparado esto:

- se ha quitado el taint de control-plane de `controlplane`, para que también acepte Pods,
- `controlplane` lleva las labels `disktype=ssd` y `zone=zona-a` (el papel de `kcna-worker`),
- `node01` lleva `disktype=hdd` y `zone=zona-b` (el papel de `kcna-worker2`).

Así cada regla de scheduling sigue teniendo dos destinos distintos.

Todo se hace en el namespace `lab-04`. Los manifiestos están en `/root/lab`. Las labels y taints que pongas tú en los nodos llevan el prefijo `lab-04`.

Cómo usarlo:

- Haz clic en un comando para ejecutarlo en la terminal.
- Al final de cada paso pulsa **CHECK**: el escenario comprueba el estado del clúster antes de dejarte avanzar.
- La sesión dura como máximo una hora y el clúster se borra al terminar.

Espera a que la terminal muestre los dos nodos con sus labels y pulsa **START**.
