# Pods, labels y ReplicaSets

Este escenario es la primera parte del laboratorio del módulo 03 de **Ruta Cloud Native**. Trabajas en un clúster real de Kubernetes con dos nodos: `controlplane` y `node01`.

En unos 30 minutos vas a:

- crear un Pod desde la línea de comandos y obtener su manifiesto YAML,
- filtrar Pods por labels,
- ver un Pod con init container y sidecar,
- observar las fases de un Pod según su `restartPolicy`,
- comprobar cómo un ReplicaSet repone y descarta Pods.

Todo se hace en el namespace `lab-03`, que se crea solo al arrancar. Los manifiestos están en `/root/lab`.

Cómo usarlo:

- Haz clic en un comando para ejecutarlo en la terminal.
- Al final de cada paso pulsa **CHECK**: el escenario comprueba el estado del clúster antes de dejarte avanzar.
- La sesión dura como máximo una hora y el clúster se borra al terminar.

Espera a que la terminal muestre los dos nodos y pulsa **START**.
