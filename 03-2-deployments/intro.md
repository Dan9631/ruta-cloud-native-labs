# Deployments, configuración y Jobs

Este escenario es la segunda parte del laboratorio del módulo 03 de **Ruta Cloud Native**. No depende de la primera: el clúster empieza limpio, con dos nodos (`controlplane` y `node01`).

En unos 40 minutos vas a:

- crear un Deployment y actualizarlo sin corte de servicio,
- provocar una actualización rota y deshacerla,
- trabajar de forma declarativa con `kubectl apply`,
- inyectar configuración con ConfigMaps y Secrets,
- ejecutar tareas con Jobs y CronJobs.

Todo se hace en el namespace `lab-03`, que se crea solo al arrancar. Los manifiestos están en `/root/lab`.

Haz clic en un comando para ejecutarlo y pulsa **CHECK** al final de cada paso. La sesión dura como máximo una hora.

Espera a que la terminal muestre los dos nodos y pulsa **START**.
