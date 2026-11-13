Un build **multi-stage** usa varias etapas `FROM`: una con herramientas para generar el resultado y otra final que solo lo copia. Lee la receta:

`cat /root/lab/Containerfile.multistage`{{exec}}

Constrúyela y compara:

`cd /root/lab && podman build -f Containerfile.multistage -t kcna-web:multi .`{{exec}}

`podman images --filter reference=kcna-web`{{exec}}

`podman images --filter reference=busybox`{{exec}}

```text
[1/2] STEP 1/3: FROM busybox:1.37 AS build
[1/2] STEP 2/3: WORKDIR /out
[1/2] STEP 3/3: RUN echo "<h1>Generado en la etapa build</h1>" > index.html && ...
[2/2] STEP 1/3: FROM nginx:1.27-alpine
[2/2] STEP 2/3: COPY --from=build /out/index.html /usr/share/nginx/html/index.html
[2/2] STEP 3/3: EXPOSE 80
Successfully tagged localhost/kcna-web:multi
REPOSITORY               TAG    IMAGE ID      CREATED         SIZE
localhost/kcna-web       multi  eb477985827d  14 seconds ago  49.7 MB
...
```

Mira qué contiene la página generada y cuántas capas tiene la imagen final:

`podman run --rm kcna-web:multi cat /usr/share/nginx/html/index.html`{{exec}}

`podman image inspect kcna-web:multi | jq '.[0].RootFS.Layers | length'`{{exec}}

**Qué observar**

- La imagen final pesa lo mismo que nginx más tu archivo, y tiene las mismas 9 capas que `kcna-web:1.0`: nada de la etapa `build` (busybox) viaja en ella.
- `podman run ... cat` reemplaza el `CMD` de la imagen: el contenedor imprime el archivo y termina.
- Con un compilador real (Go, Java, Node) la diferencia es de cientos de MB y la imagen final tiene menos superficie de ataque.

Pulsa **CHECK**.
