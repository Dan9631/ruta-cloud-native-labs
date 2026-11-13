**Caso 5 · `reporter`** — archivo `/root/lab/rotos/05-reporter.yaml`.

**Síntoma:** se queda «creando el contenedor».

`kubectl get pods -n lab-09 -l app=reporter`{{exec}}

**Objetivo:** el Deployment `reporter` con su réplica `READY 1/1`, en `Running` y con `RESTARTS` a 0.

**Pistas**

- La imagen está descargada, pero el contenedor no se puede construir. Aquí no hay logs: el contenedor nunca se ejecutó. Ve a los eventos del Pod.
- El evento nombra un objeto que no existe. Lista los objetos de ese tipo que **sí** hay en `lab-09` y compara los nombres letra a letra.
- Hay dos arreglos válidos: corregir la referencia en el Deployment o crear el objeto con el nombre que espera.

Cuando creas que está, pulsa **CHECK**.

**Si te atascas**

`cat /root/solucion/caso5-reporter.txt`{{copy}}
