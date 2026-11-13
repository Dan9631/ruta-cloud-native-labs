**Caso 2 · `api`** — archivo `/root/lab/rotos/02-api.yaml`.

**Síntoma:** se cae al arrancar una y otra vez.

`kubectl get pods -n lab-09 -l app=api`{{exec}}

**Objetivo:** el Deployment `api` con su réplica `READY 1/1`, en `Running` y con `RESTARTS` a 0.

**Pistas**

- El contenedor **sí** llega a ejecutarse: lo que buscas está en lo que la aplicación dijo antes de morir. ¿Qué opción de `kubectl logs` muestra el contenedor anterior?
- `describe` te dará el `Last State` y el `Exit Code`. ¿Es un 137 o un error de la propia aplicación?
- Para cambios puntuales en un Deployment existe `kubectl set env`.

Cuando creas que está, pulsa **CHECK**.

**Si te atascas**

La solución está en `/root/solucion`. Inténtalo antes de mirarla:

`cat /root/solucion/caso2-api.txt`{{copy}}
