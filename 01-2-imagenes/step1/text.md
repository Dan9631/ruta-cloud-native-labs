Lee la receta y el contenido que va a copiar:

`cd /root/lab && cat Containerfile`{{exec}}

`cat /root/lab/web/index.html`{{exec}}

Construye la imagen:

`cd /root/lab && podman build -t kcna-web:1.0 .`{{exec}}

`podman images kcna-web`{{exec}}

```text
STEP 1/5: FROM nginx:1.27-alpine
STEP 2/5: LABEL org.opencontainers.image.title="kcna-web" ...
--> fc5e1d2069c5
STEP 3/5: ENV KCNA_MODULO=01
--> eadeaa0a4981
STEP 4/5: COPY web/ /usr/share/nginx/html/
--> b4f5670b2368
STEP 5/5: EXPOSE 80
COMMIT kcna-web:1.0
--> d102d0578661
Successfully tagged localhost/kcna-web:1.0
REPOSITORY          TAG   IMAGE ID      CREATED        SIZE
localhost/kcna-web  1.0   d102d0578661  5 seconds ago  49.7 MB
```

Ahora mira sus capas y sus metadatos. `podman image inspect` devuelve JSON y `jq` extrae lo que interesa:

`podman history kcna-web:1.0`{{exec}}

`podman image inspect nginx:1.27-alpine | jq '.[0].RootFS.Layers | length'`{{exec}}

`podman image inspect kcna-web:1.0 | jq '.[0].RootFS.Layers | length'`{{exec}}

`podman image inspect kcna-web:1.0 | jq '.[0].Labels'`{{exec}}

`podman image inspect kcna-web:1.0 | jq -c '.[0].Config | [.Cmd, .Entrypoint, (.ExposedPorts | keys)]'`{{exec}}

```text
ID            CREATED        CREATED BY                                     SIZE   COMMENT
b4f5670b2368  1 minute ago   /bin/sh -c #(nop) EXPOSE 80                    0B
<missing>     1 minute ago   /bin/sh -c #(nop) COPY dir:3060a090c857085...  4.1kB
6769dc3a703c  1 minute ago   /bin/sh -c #(nop) ENV KCNA_MODULO=01           0B
<missing>     1 minute ago   /bin/sh -c #(nop) LABEL org.opencontainers...  0B     FROM docker.io/library/nginx:1.27-alpine
<missing>     18 months ago  RUN /bin/sh -c set -x     && apkArch="$(ca...  37MB   buildkit.dockerfile.v0
...
8
9
{
  "io.buildah.version": "...",
  "maintainer": "NGINX Docker Maintainers <docker-maint@nginx.com>",
  "org.opencontainers.image.description": "Pagina estatica del curso KCNA",
  "org.opencontainers.image.title": "kcna-web",
  "org.opencontainers.image.version": "1.0"
}
[["nginx","-g","daemon off;"],["/docker-entrypoint.sh"],["80/tcp"]]
```

**Qué observar**

- El `.` final del build es el **contexto de build**: lo que se envía al constructor. De ahí sale `web/`.
- Podman nombra las imágenes locales como `localhost/<nombre>:<tag>`. Ese nombre completo es el que usarías en Kubernetes.
- La base tiene **8 capas** y la tuya **9**: solo `COPY` añadió una capa (unos kB). `LABEL`, `ENV` y `EXPOSE` son metadatos (0B).
- Las capas de nginx se reutilizan, no se copian.
- `CMD` y `ENTRYPOINT` se heredaron de la imagen base.

Pulsa **CHECK** cuando exista `localhost/kcna-web:1.0`.
