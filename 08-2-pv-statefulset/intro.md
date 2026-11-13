# PV estático, StatefulSets y volúmenes projected

Este escenario es la segunda parte del laboratorio del módulo 08 de **Ruta Cloud Native**. Trabajas en un clúster real de Kubernetes con dos nodos: `controlplane` y `node01`.

En unos 40 minutos vas a:

- crear a mano una StorageClass sin aprovisionador, un PV `hostPath` y un PVC que lo reclama,
- ver qué pasa con un PV `Retain` cuando se borra su PVC, y cómo reutilizarlo,
- desplegar un StatefulSet en el que cada réplica tiene su propio PVC,
- juntar un ConfigMap, un Secret y datos del Pod en un único volumen projected.

Al arrancar, el escenario prepara el almacenamiento dinámico: instala **local-path-provisioner** si el clúster no lo trae y deja una StorageClass `standard` por defecto (`rancher.io/local-path`, `Delete`, `WaitForFirstConsumer`). No necesitas haber hecho la primera parte.

El plano de control lleva el taint `NoSchedule`, así que todos los Pods del laboratorio van a `node01`.

Todo se hace en el namespace `lab-08`, que se crea solo al arrancar. Los manifiestos están en `/root/lab`.

Cómo usarlo:

- Haz clic en un comando para ejecutarlo en la terminal.
- Al final de cada paso pulsa **CHECK**: el escenario comprueba el estado del clúster antes de dejarte avanzar.
- La sesión dura como máximo una hora y el clúster se borra al terminar.

La preparación tarda alrededor de un minuto. Espera a que la terminal muestre los nodos y las StorageClasses y pulsa **START**.
