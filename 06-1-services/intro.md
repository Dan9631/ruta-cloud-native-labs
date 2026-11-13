# Services y DNS

Este escenario es la primera parte del laboratorio del módulo 06 de **Ruta Cloud Native**. Trabajas en un clúster real de Kubernetes con dos nodos: `controlplane` y `node01`.

Vas a desplegar `traefik/whoami`, un servidor web diminuto que responde con el nombre y la IP del Pod que atendió la petición, y a alcanzarlo de varias formas.

En unos 35 minutos vas a:

- mirar la red de nodos y de Pods, el CNI y kube-proxy,
- crear un Service ClusterIP y resolverlo por DNS desde dentro de un Pod,
- comprobar cómo reparte las conexiones y cómo cambian los EndpointSlices al escalar,
- crear un Service headless y uno ExternalName,
- abrir un NodePort y entrar desde fuera del clúster.

Todo se hace en el namespace `lab-06`, que se crea solo al arrancar. Los manifiestos están en `/root/lab`. Para que los Pods se repartan entre los dos nodos, al arrancar se quita el taint de `controlplane` que impide programar Pods normales en él.

Cómo usarlo:

- Haz clic en un comando para ejecutarlo en la terminal.
- Al final de cada paso pulsa **CHECK**: el escenario comprueba el estado del clúster antes de dejarte avanzar.
- La sesión dura como máximo una hora y el clúster se borra al terminar.

Espera a que la terminal muestre los dos nodos y pulsa **START**.
