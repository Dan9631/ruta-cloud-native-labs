# Reto del módulo 04

Este escenario cierra el laboratorio del módulo 04 de **Ruta Cloud Native**. Aquí no hay comandos para copiar: recibes los requisitos y colocas las cargas con lo que practicaste en las dos partes anteriores.

El clúster empieza limpio, con el namespace `lab-04` creado y dos nodos preparados igual que en las partes anteriores:

| Nodo | Labels | Taints al empezar |
|---|---|---|
| `controlplane` | `disktype=ssd`, `zone=zona-a` | ninguno (se le quitó el de control-plane) |
| `node01` | `disktype=hdd`, `zone=zona-b` | ninguno |

En el lab local del curso el reto usa tres nodos. Aquí `node01` hace de nodo con GPU (el papel de `kcna-worker2`) y `controlplane` de nodo con disco ssd (el papel de `kcna-worker`).

Puedes pulsar **CHECK** las veces que quieras: te dice si todavía falta algo. La sesión dura como máximo una hora.

Espera a que la terminal muestre los dos nodos y pulsa **START**.
