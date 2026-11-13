# Reto del módulo 07

Este escenario cierra el laboratorio del módulo 07 de **Ruta Cloud Native**. Aquí no hay comandos para copiar: recibes los requisitos y los resuelves con lo que practicaste en el laboratorio guiado.

El clúster empieza limpio, con dos nodos. Al arrancar se preparan:

- el namespace `lab-07` con `whoami-v1` (2 réplicas) y `whoami-v2` (1 réplica), cada uno con su Service,
- los CRD de Gateway API y **Traefik**, con el Gateway `traefik-gateway` en el namespace `traefik`, que escucha en el puerto **30080** de los nodos.

Tarda entre uno y tres minutos. Puedes pulsar **CHECK** las veces que quieras: te dice si todavía falta algo. Calcula unos 25 minutos; la sesión dura como máximo una hora.

Espera a que la terminal diga que Traefik responde y pulsa **START**.
