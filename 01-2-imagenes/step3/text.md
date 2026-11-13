Primero borra el contenedor del paso anterior:

`podman rm -f web2`{{exec}}

Tu imagen solo existe en el almacén local de Podman. Para que otra máquina (por ejemplo, un nodo de Kubernetes) la pueda descargar, hay que subirla a un **registry**. Arranca uno en un contenedor, escuchando en el puerto 5000:

`podman run -d --name registry -p 5000:5000 registry:2.8.3`{{exec}}

El nombre de una imagen dice a qué registry pertenece. Ponle a tu imagen un segundo nombre que apunte a `localhost:5000`:

`podman tag kcna-web:1.0 localhost:5000/kcna-web:1.0`{{exec}}

`podman images | grep kcna-web`{{exec}}

```text
localhost:5000/kcna-web  1.0   d102d0578661  10 minutes ago  49.7 MB
localhost/kcna-web       1.0   d102d0578661  10 minutes ago  49.7 MB
```

Súbela. Este registry de prácticas habla HTTP sin TLS, por eso `--tls-verify=false`:

`podman push --tls-verify=false localhost:5000/kcna-web:1.0`{{exec}}

Pregunta al registry qué guarda. Es una API HTTP (la *distribution-spec* de OCI):

`curl -s http://localhost:5000/v2/_catalog; echo`{{exec}}

`curl -s http://localhost:5000/v2/kcna-web/tags/list; echo`{{exec}}

```text
{"repositories":["kcna-web"]}
{"name":"kcna-web","tags":["1.0"]}
```

Quita el nombre del registry de tu almacén local y descárgala de nuevo:

`podman rmi localhost:5000/kcna-web:1.0`{{exec}}

`podman pull --tls-verify=false localhost:5000/kcna-web:1.0`{{exec}}

```text
Untagged: localhost:5000/kcna-web:1.0
Trying to pull localhost:5000/kcna-web:1.0...
Getting image source signatures
Copying blob ... skipped: already exists
...
```

**Qué observar**

- `podman tag` no copia nada: crea otro nombre para la misma imagen (mismo `IMAGE ID`). El nombre es `registry/repositorio:tag`.
- `push` sube las capas y el manifiesto al registry; `pull` los baja. Las capas se identifican por su hash, así que las que ya tienes no se vuelven a descargar.
- `podman rmi` de un nombre solo lo quita: la imagen sigue mientras le quede otro nombre.
- Un registry real (Docker Hub, `quay.io`, `ghcr.io`, Harbor...) usa TLS y pide `login` para subir. En Kubernetes, para descargar de un registry privado se usan **imagePullSecrets**.

Pulsa **CHECK** cuando el registry tenga `kcna-web:1.0`.
