En el namespace `lab-06`, publica una nueva aplicación "tienda" de varias formas a la vez:

1. Un Deployment **`tienda`** con la imagen `traefik/whoami:v1.11` y **2 réplicas** (label `app=tienda`).
2. Un Service **`tienda`** de tipo ClusterIP que escuche en el puerto **8080** y envíe al puerto 80 de los Pods.
3. Un Service headless **`tienda-headless`** que seleccione los mismos Pods.
4. Un Ingress que publique la tienda en la ruta **`/lab06/tienda`** de Traefik, a través del Service `tienda`.
5. Una HTTPRoute colgada de `traefik-gateway` (namespace `traefik`) que la publique en la ruta **`/lab06/gw-tienda`**.

Para probar las rutas, usa la IP de un nodo y el NodePort de Traefik:

`CP=$(kubectl get node controlplane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}'); echo $CP`{{exec}}

`curl -s http://$CP:30800/lab06/tienda`{{copy}}

`curl -s http://$CP:30800/lab06/gw-tienda`{{copy}}

Cuando funcionen, la respuesta incluye `Hostname: tienda-...`. También puedes abrir [la tienda por el Ingress]({{TRAFFIC_HOST1_30800}}/lab06/tienda) en el navegador.

**Pistas**

- `kubectl expose` copia el selector del Deployment. Mira sus opciones `--port`, `--target-port`, `--name` y `--cluster-ip`.
- `kubectl create ingress --help`{{exec}}: en `--rule`, un `*` al final del path indica `pathType: Prefix`.
- La HTTPRoute no tiene comando `create`: escribe un YAML. Inspírate en el de la segunda parte o consulta `kubectl explain httproute.spec.parentRefs`{{exec}}.
- Si una ruta devuelve `404 page not found`, Traefik no tiene ninguna regla que coincida. Revisa el path y el estado de la HTTPRoute con `kubectl describe httproute -n lab-06`.

Cuando creas que está, pulsa **CHECK**.

**Si te atascas**

Hay una solución completa en `/root/solucion`. Inténtalo antes de mirarla:

`cat /root/solucion/pasos.txt`{{copy}}
