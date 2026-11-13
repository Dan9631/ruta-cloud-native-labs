# Diagnóstico: get, describe, eventos y logs

Este escenario es la primera parte del laboratorio del módulo 09 de **Ruta Cloud Native**. Trabajas en un clúster real de Kubernetes con dos nodos: `controlplane` y `node01`.

En `/root/lab/rotos` hay **6 manifiestos rotos**, cada uno con un fallo distinto (el último tiene dos). Los vas a desplegar todos a la vez, como si heredaras un namespace en llamas.

En unos 30 minutos vas a:

- aplicar la metodología **de afuera hacia adentro**: `get → describe → events → logs → exec`,
- diagnosticar y arreglar el primer caso, `frontend`,
- leer logs de varios Pods a la vez y probar la red desde un Pod cliente,
- abrir una aplicación con `kubectl port-forward` sin exponerla.

Los otros cinco casos son el reto (escenario 3 de 3). Aquí solo vas a fijarte en sus síntomas.

Todo se hace en el namespace `lab-09`, que se crea solo al arrancar. Para que el clúster se parezca al del curso, el arranque deja `controlplane` con su taint de control-plane (las aplicaciones van a `node01`) y pone a `node01` los labels `disktype=ssd` y `zone=zona-a`.

Cómo usarlo:

- Haz clic en un comando para ejecutarlo en la terminal.
- Al final de cada paso pulsa **CHECK**: el escenario comprueba el estado del clúster antes de dejarte avanzar.
- La sesión dura como máximo una hora y el clúster se borra al terminar.

Espera a que la terminal muestre los dos nodos y pulsa **START**.
