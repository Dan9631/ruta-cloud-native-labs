**Caso 4 · `worker`** — archivo `/root/lab/rotos/04-worker.yaml`.

**Síntoma:** arranca, carga datos... y muere.

`kubectl get pods -n lab-09 -l app=worker`{{exec}}

**Objetivo:** el Deployment `worker` con su réplica `READY 1/1`, en `Running` y con `RESTARTS` a 0.

**Pistas**

- En `describe`, busca el `Last State` del contenedor: su `Reason` y su `Exit Code`. Recuerda que 137 = 128 + 9 (SIGKILL).
- Los logs del contenedor anterior se cortan en una línea concreta. ¿Cuánta memoria dice que va a cargar?
- Compara esa cifra con los `resources` del manifiesto. Existe `kubectl set resources`.

Cuando creas que está, pulsa **CHECK**.

**Si te atascas**

`cat /root/solucion/caso4-worker.txt`{{copy}}
