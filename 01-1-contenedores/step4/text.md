Primero borra el contenedor del paso anterior (`-f` lo para y lo borra en un solo paso):

`podman rm -f limitado`{{exec}}

Para `web1` y míralo con `ps -a`, que también lista los contenedores parados:

`podman stop web1`{{exec}}

`podman ps -a --filter name=^web1`{{exec}}

```text
CONTAINER ID  IMAGE                                COMMAND               CREATED        STATUS                    PORTS                 NAMES
c90a6331da02  docker.io/library/nginx:1.27-alpine  nginx -g daemon o...  9 minutes ago  Exited (0) 3 seconds ago  0.0.0.0:8081->80/tcp  web1
```

Vuelve a arrancarlo y busca la nota del paso 2:

`podman start web1 && podman exec web1 cat /tmp/nota.txt`{{exec}}

```text
web1
hola desde web1
```

Ahora bórralo y comprueba que ya no existe:

`podman rm -f web1`{{exec}}

`podman ps -a --filter name=^web1`{{exec}}

**Qué observar**

- Un contenedor parado sigue existiendo, con su capa escribible, hasta que lo borras con `rm`. Por eso la nota sobrevive al `stop`.
- Al borrarlo, la capa escribible desaparece con él: los contenedores son **efímeros** y los datos que deben durar van en volúmenes.
- `podman rm -f` para y borra en un paso.

Pulsa **CHECK** cuando no quede ningún contenedor.
