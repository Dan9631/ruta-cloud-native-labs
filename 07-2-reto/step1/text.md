En el namespace `lab-07`, con `whoami-v1` y `whoami-v2` ya desplegados:

1. Crea un Pod **`reto-sidecar`** con:
   - un contenedor principal **`app`** (`busybox:1.37`) que cada 3 segundos añada la línea `<fecha> pedido procesado` a `/datos/app.log`,
   - un **sidecar nativo** llamado **`shipper`** (`busybox:1.37`) que haga `tail -F /datos/app.log`,
   - un volumen `emptyDir` que compartan los dos.
2. Crea una HTTPRoute **`reto-canary`**, colgada del Gateway `traefik-gateway` (namespace `traefik`), para el path **`/lab07/reto`**, que:
   - envíe **siempre a v2** las peticiones que lleven la cabecera **`x-version: v2`** (para que el equipo de QA pruebe la versión nueva),
   - reparta el resto **80/20** entre `whoami-v1` y `whoami-v2`.

**Pistas**

- En Gateway API una regla puede combinar `path` y `headers` dentro del mismo `matches`. Cuando dos reglas coinciden, gana la más específica.
- `kubectl explain pod.spec.initContainers.restartPolicy`{{exec}}
- `kubectl explain httproute.spec.rules.matches.headers`{{exec}}
- El Gateway escucha en el puerto 30080 de los nodos. Guarda la URL en una variable para probar con `curl`:

`export GW=http://$(kubectl get node controlplane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}'):30080; echo $GW`{{exec}}

- Para enviar la cabecera: `curl -s -H 'x-version: v2' $GW/lab07/reto`{{copy}}

Cuando creas que está, pulsa **CHECK**.

**Si te atascas**

Hay una solución completa en `/root/solucion`. Inténtalo antes de mirarla:

`cat /root/solucion/pasos.txt`{{copy}}
