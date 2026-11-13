# Reto del módulo 06

Este escenario cierra el laboratorio del módulo 06 de **Ruta Cloud Native**. Aquí no hay comandos para copiar: recibes los requisitos y publicas una aplicación con lo que practicaste en las dos partes anteriores.

El clúster tiene dos nodos y empieza con:

- el namespace `lab-06` vacío,
- **Traefik** como Ingress Controller (IngressClass `traefik`, por defecto) y como implementación de Gateway API, con el Gateway compartido `traefik-gateway` en el namespace `traefik`.

Traefik se publica con un Service NodePort en el puerto **30800** de los nodos. Es el equivalente al `http://localhost:8080` del clúster local del curso.

Puedes pulsar **CHECK** las veces que quieras: te dice si todavía falta algo. La sesión dura como máximo una hora.

La preparación tarda unos minutos. Espera a que la terminal muestre los dos nodos y pulsa **START**.
