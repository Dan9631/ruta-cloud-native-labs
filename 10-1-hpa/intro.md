# Autoscaling con HPA

Este escenario es la primera parte del laboratorio del módulo 10 de **Ruta Cloud Native**. Trabajas en un clúster real de Kubernetes con dos nodos: `controlplane` y `node01`.

En unos 35 minutos vas a ver un HorizontalPodAutoscaler (HPA) en acción:

- desplegar una app que consume CPU con cada petición, y su HPA,
- generar carga y ver cómo el HPA añade réplicas,
- leer por qué ha tomado cada decisión,
- quitar la carga y ver cómo vuelve a una réplica,
- consultar la documentación de la API `autoscaling/v2`.

Los tiempos están acortados (ventana de bajada de 30 s en lugar de 5 min) para verlo todo en pocos minutos. Aun así, el HPA **no es instantáneo**: en algunos pasos tendrás que esperar uno o dos minutos.

Todo se hace en el namespace `lab-10`, que se crea solo al arrancar. Al abrir el escenario también se instala **metrics-server**, que es de donde el HPA saca la CPU de los Pods. Los manifiestos están en `/root/lab`.

Cómo usarlo:

- Haz clic en un comando para ejecutarlo en la terminal.
- Al final de cada paso pulsa **CHECK**: el escenario comprueba el estado del clúster antes de dejarte avanzar.
- La sesión dura como máximo una hora y el clúster se borra al terminar.

Espera a que la terminal muestre el consumo de los dos nodos y pulsa **START**.
