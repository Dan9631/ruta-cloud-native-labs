Publica la **versión 2.0** de tu imagen y ejecútala en el clúster:

1. Construye con Podman la imagen `localhost/kcna-web:2.0`:
   - su página debe contener el texto `v2`,
   - su etiqueta OCI `org.opencontainers.image.version` debe valer `2.0`.
2. Llévala al runtime del nodo (containerd), para que el kubelet la encuentre sin descargarla.
3. Crea en el namespace `lab-01` un Pod llamado `web-v2` con esa imagen y los labels `app=kcna-web` y `version=v2`. Debe quedar `Running` y listo.

**Pistas**

- Trabaja sobre una **copia** de `/root/lab` para no tocar los originales.
- `sed -i` cambia texto dentro de un archivo. Otra opción para la etiqueta: `podman build --label clave=valor` sobrescribe la del `Containerfile`.
- Comprueba la etiqueta con `podman image inspect localhost/kcna-web:2.0 | jq '.[0].Labels'` (si no tienes `jq`, busca la línea con `grep version`).
- La imagen pasa de Podman a containerd con `podman save` y `ctr -n k8s.io images import`. `crictl images` te dice si el kubelet la ve.
- Si creaste el Pod antes de importar la imagen verás `ImagePullBackOff`: importa la imagen, borra el Pod y vuelve a crearlo.

Cuando creas que está, pulsa **CHECK**.

**Si te atascas**

Hay una solución completa en `/root/solucion`. Inténtalo antes de mirarla:

`cat /root/solucion/pasos.txt`{{copy}}
