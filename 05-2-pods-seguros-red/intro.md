# securityContext, Pod Security y NetworkPolicies

Este escenario es la segunda parte del laboratorio del módulo 05 de **Ruta Cloud Native**. No depende de la primera: el clúster empieza limpio, con dos nodos (`controlplane` y `node01`).

En unos 40 minutos vas a:

- comparar un contenedor que corre como root con uno endurecido,
- aplicar el perfil `restricted` de Pod Security Admission a un namespace y ver qué rechaza,
- cerrar el tráfico de entrada con una NetworkPolicy y abrir solo el que quieres,
- comprobar que un Secret en base64 no está cifrado, ni en la API ni en etcd.

Todo se hace en el namespace `lab-05`, que se crea solo al arrancar. También se crea la ServiceAccount `lector` de la primera parte, que solo puede leer Pods. Los manifiestos están en `/root/lab`.

Haz clic en un comando para ejecutarlo y pulsa **CHECK** al final de cada paso. La sesión dura como máximo una hora.

Espera a que la terminal muestre los dos nodos y pulsa **START**.
