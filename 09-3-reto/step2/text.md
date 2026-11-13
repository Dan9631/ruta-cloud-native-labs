**Caso 3 · `cache`** — archivo `/root/lab/rotos/03-cache.yaml`.

**Síntoma:** nunca llega a arrancar.

`kubectl get pods -n lab-09 -l app=cache -o wide`{{exec}}

**Objetivo:** el Deployment `cache` con su réplica `READY 1/1`, en `Running` y con `RESTARTS` a 0. Sin tocar los nodos.

**Pistas**

- Fíjate en las columnas `IP` y `NODE`. Si están vacías, ¿qué componente no ha hecho su trabajo?
- El evento que buscas lo emite el `default-scheduler`. Léelo entero: dice qué le pasa a **cada** nodo.
- Compara lo que pide el Pod con los labels que de verdad tienen los nodos: `kubectl get nodes --show-labels` o `-L` con el label que te interese.

Cuando creas que está, pulsa **CHECK**.

**Si te atascas**

`cat /root/solucion/caso3-cache.txt`{{copy}}
