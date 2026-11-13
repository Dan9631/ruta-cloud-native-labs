# Reto del módulo 09

Este escenario cierra el laboratorio del módulo 09 de **Ruta Cloud Native**. Heredas un namespace en llamas: al arrancar se despliegan en `lab-09` las seis aplicaciones de `/root/lab/rotos`. El caso 1 (`frontend`) ya viene arreglado; los casos 2 a 6 son tuyos.

Cada paso es una avería. Recibes el síntoma, no el comando: diagnostica con la metodología **de afuera hacia adentro** (`get → describe → events → logs → exec → debug`) y, antes de arreglar, escribe para ti **cuál es la causa y qué comando te la demostró**.

Reglas:

- No cambies las imágenes (busybox, redis, nginx) por otras.
- No toques los nodos: nada de añadir labels ni quitar taints.
- Corrige los manifiestos de `/root/lab/rotos` y aplícalos, o usa `kubectl edit`, `kubectl set env`, `kubectl set resources`, etc.

El clúster tiene dos nodos: `controlplane`, con su taint de control-plane, y `node01`, con los labels `disktype=ssd` y `zone=zona-a`, como uno de los workers del curso.

Puedes pulsar **CHECK** las veces que quieras: te dice qué falta. Si te atascas, cada paso indica dónde está su solución en `/root/solucion`. La sesión dura como máximo una hora.

Espera a que la terminal muestre los Pods de `lab-09` y pulsa **START**.
