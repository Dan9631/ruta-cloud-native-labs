# Volúmenes, PVC y aprovisionamiento dinámico

Este escenario es la primera parte del laboratorio del módulo 08 de **Ruta Cloud Native**. Trabajas en un clúster real de Kubernetes con dos nodos: `controlplane` y `node01`.

En unos 35 minutos vas a:

- compartir un volumen `emptyDir` entre dos contenedores y ver que muere con el Pod,
- crear un PersistentVolumeClaim y ver por qué se queda en `Pending`,
- ver cómo el aprovisionador crea el PersistentVolume cuando un Pod usa el PVC,
- comprobar que los datos del PVC sobreviven al Pod y encontrarlos en el disco del nodo,
- intentar ampliar el volumen.

Al arrancar, el escenario prepara el almacenamiento dinámico: instala **local-path-provisioner** si el clúster no lo trae y deja una StorageClass `standard` por defecto. Crea cada volumen como una carpeta en el disco del nodo donde corre el Pod. No es CSI ni sirve para producción, pero se comporta como cualquier StorageClass para aprender.

El plano de control lleva el taint `NoSchedule`, así que todos los Pods del laboratorio van a `node01`.

Todo se hace en el namespace `lab-08`, que se crea solo al arrancar. Los manifiestos están en `/root/lab`.

Cómo usarlo:

- Haz clic en un comando para ejecutarlo en la terminal.
- Al final de cada paso pulsa **CHECK**: el escenario comprueba el estado del clúster antes de dejarte avanzar.
- La sesión dura como máximo una hora y el clúster se borra al terminar.

La preparación tarda alrededor de un minuto. Espera a que la terminal muestre los nodos y las StorageClasses y pulsa **START**.
